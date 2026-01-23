// Prototype
// Прототип - это паттерн проектирования,
// который позволяет копировать объекты, то есть создавать клоны.
package main

import (
	"fmt"
	"io"
	"strings"
)

type WriterOpts struct {
	Level int
}

type Node interface {
	Clone() Node
	WriteEntry(writer io.Writer, opts WriterOpts) error
}

type File struct {
	Name string
}

func (f *File) Clone() Node {
	return &File{
		Name: f.Name,
	}
}

func (f *File) WriteEntry(writer io.Writer, opts WriterOpts) error {
	_, err := fmt.Fprintf(writer, "%s %s\n", strings.Repeat("	", opts.Level), f.Name)
	return err
}

type Folder struct {
	File
	Children []Node
}

func (f *Folder) Clone() Node {
	clone := &Folder{
		Children: make([]Node, len(f.Children)),
	}

	clone.Name = f.Name

	for i, v := range f.Children {
		clone.Children[i] = v.Clone()
	}

	return clone
}

func (f *Folder) WriteEntry(writer io.Writer, opts WriterOpts) error {
	if err := f.File.WriteEntry(writer, opts); err != nil {
		return err
	}

	opts.Level += 1

	for _, v := range f.Children {
		if err := v.WriteEntry(writer, opts); err != nil {
			return err
		}
	}

	return nil
}

func (f *Folder) String() string {
	var sb strings.Builder
	f.WriteEntry(&sb, WriterOpts{Level: 0})
	return sb.String()
}

func main() {
	folder := &Folder{
		Children: []Node{
			&File{Name: "file1"},
			&File{Name: "file2"},
			&Folder{
				Children: []Node{
					&File{Name: "file3"},
					&File{Name: "file4"},
				},
				File: File{Name: "subfolder"},
			},
		},
		File: File{Name: "root"},
	}
	fmt.Printf("Original:\n%s\n", folder)

	clone := folder.Clone()
	fmt.Printf("Clone:\n%s\n", clone)
}
