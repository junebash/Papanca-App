import ComposableArchitecture
import SwiftUI


// MARK: - Basic

public struct ExpandableField<Label: View, Content: View>: View {
  let label: Label
  let content: () -> Content
  let isExpanded: Bool

  public init(
    isExpanded: Bool,
    @ViewBuilder content: @escaping () -> Content,
    @ViewBuilder label: () -> Label
  ) {
    self.isExpanded = isExpanded
    self.label = label()
    self.content = content
  }

  public var body: some View {
    VStack {
      label

      if isExpanded {
        content()
      }
    }
    .padding(4)
    .background { PapancaButtonBackground() }
    .animation(.default, value: isExpanded)
    .compositingGroup()
  }
}


public struct ExpandableStoreField<Label: View, Content: View, State, Action>: View {
  private let store: Store<State?, Action>
  private let content: (Store<State, Action>) -> Content
  private let label: Label
  @ObservedObject private var isExpandedViewStore: ViewStore<Bool, Never>

  init(
    store: Store<State?, Action>,
    @ViewBuilder content: @escaping (Store<State, Action>) -> Content,
    @ViewBuilder label: () -> Label
  ) {
    self.store = store
    self.isExpandedViewStore = ViewStore(store.scope(
      state: { $0 != nil },
      action: absurd
    ))
    self.content = content
    self.label = label()
  }

  public var body: some View {
    VStack {
      label

      IfLetStore(store, then: content)
    }
    .padding(4)
    .background { PapancaButtonBackground() }
    .animation(.default, value: isExpandedViewStore.state)
    .compositingGroup()
  }
}


// MARK: - Titled

public struct TitledExpandableField<PopUpContent: View>: View {
  let title: String
  let selection: String
  let content: () -> PopUpContent
  private var placeholderColor: Color?

  @Binding private var showingContent: Bool
  @Namespace private var namespace: Namespace.ID

  private struct AnimatableChange: Equatable {
    var showingContent: Bool
    var selection: String
  }

  private var change: AnimatableChange {
    .init(showingContent: showingContent, selection: selection)
  }

  public init(
    title: String,
    selection: String,
    showingContent: Binding<Bool>,
    placeholderColor: Color? = nil,
    @ViewBuilder content: @escaping () -> PopUpContent
  ) {
    self.title = title
    self.selection = selection
    self._showingContent = showingContent
    self.placeholderColor = placeholderColor
    self.content = content
  }

  public var body: some View {
    ExpandableField(isExpanded: showingContent) {
      content()
    } label: {
      ZStack(alignment: .topLeading) {
        Text(selection)
          .fontWeight(showingContent ? .bold : nil)
          .padding(4)

        Text(title)
          .font(selection.isEmpty ? nil : .caption)
          .fontWeight(selection.isEmpty ? nil : .thin)
          .padding(EdgeInsets(top: 1, leading: 2, bottom: 1, trailing: 2))
          .background(placeholderBackground)
          .foregroundColor(
            selection.isEmpty
            ? (placeholderColor ?? Color(uiColor: .placeholderText))
            : .primary
          )
          .alignmentGuide(selection.isEmpty ? .bottom : .top) {
            selection.isEmpty ? 0.0 : $0[.bottom]
          }
          .frame(alignment: selection.isEmpty ? .center : .top)
          .transition(.slide)
      }
      .onTapGesture(perform: { showingContent.toggle() })
    }
    .padding(.top)
    .animation(.default, value: change)
  }

  @ViewBuilder
  private var placeholderBackground: some View {
    let shape = RoundedRectangle(cornerRadius: 5)
    selection.isEmpty ? nil : ZStack {
      Color(uiColor: .tertiarySystemBackground)
        .clipShape(shape)
      shape
        .stroke(Color(uiColor: .quaternaryLabel))
    }
  }
}


// MARK: - Selection

public struct ExpandableSelectionField<Content: View>: View {
  let title: String
  let selection: String
  let content: () -> Content

  @Binding private var showingContent: Bool
  @Namespace private var namespace: Namespace.ID

  public init(
    title: String,
    selection: String,
    showingContent: Binding<Bool>,
    @ViewBuilder content: @escaping () -> Content
  ) {
    self.title = title
    self.selection = selection
    self._showingContent = showingContent
    self.content = content
  }

  public var body: some View {
    TitledExpandableField(title: title, selection: selection, showingContent: $showingContent) {
      content()

      Button("Done") {
        showingContent.toggle()
      }
      .buttonStyle(.bordered)
      .padding(.top, 4)
    }
  }
}


// MARK: - Previews

enum ExpandableSelectionField_Previews: PreviewProvider {
  private struct Test: View {
    @State var selection: String = "hello how are you i am fine what is your name my name is harry"
    @State var showing = false

    var body: some View {
      ExpandableSelectionField(title: "Pop-Up Test", selection: selection, showingContent: $showing) {
        Button("tap me!") {
          selection = selection.isEmpty ? UUID().uuidString : ""
        }
      }
    }
  }

  private struct ExpandableFieldTest: View {
    @State var isExpanded = false

    var body: some View {
      ExpandableField(isExpanded: isExpanded) {
        VStack {
          Text("Goodbye")
          Button("Bye") { isExpanded = false }
        }
      } label: {
        Button("Hello") { isExpanded = true }
      }
    }
  }

  static var previews: some View {
    ExpandableFieldTest()
    
    ExpandableSelectionField(title: "Hello", selection: "", showingContent: .constant(false)) {
      Color.orange
    }
    
    Self.Test()

    Self.Test().transformEnvironment(\.dynamicTypeSize) {
      $0 = DynamicTypeSize.xxxLarge
    }
  }
}
