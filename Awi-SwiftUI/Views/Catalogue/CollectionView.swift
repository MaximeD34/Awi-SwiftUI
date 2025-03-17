import SwiftUI

struct CollectionView: View {
    var body: some View {
        VStack {
            Text("Collection")
                .font(.largeTitle)
            Spacer()
        }
        .padding()
    }
}

struct CollectionView_Previews: PreviewProvider {
    static var previews: some View {
        CollectionView()
    }
}
