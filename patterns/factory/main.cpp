/*
 Фабричный метод - это порождающий паттерн проектирования,
 который определяет общий интерфейс для создания объектов в суперклассе,
 позволяя подклассам изменять тип создаваемых объектов.
*/

#include <iostream>
#include <memory>

class Document {
public:
  virtual ~Document() {}
  virtual void save() = 0;
  virtual void open() = 0;
};

class TextDocument : public Document {
public:
  void open() override final { std::cout << "save text doc" << std::endl; }
  void save() override final { std::cout << "open text doc" << std::endl; }
};

class HTMLDocument : public Document {
public:
  void open() override final { std::cout << "html text doc" << std::endl; }
  void save() override final { std::cout << "html text doc" << std::endl; }
};

class DocumentFactory {

  virtual std::unique_ptr<Document> createDocument() = 0;

public:
  std::unique_ptr<Document> newDocument() { return createDocument(); }
};

class TextDocumentFactory : public DocumentFactory {
  std::unique_ptr<Document> createDocument() final {
    return std::make_unique<TextDocument>();
  }
};

class HTMLDocumentFactory : public DocumentFactory {
  std::unique_ptr<Document> createDocument() final {
    return std::make_unique<HTMLDocument>();
  }
};

int main() {
  auto factory = std::make_unique<TextDocumentFactory>();

  auto doc = factory->newDocument();
  doc->open();
  doc->save();

  return 0;
}
