//  selectedCategory({required String categoryId}) {
//     subCategory = "".obs;
//     subcategoryListFiltered.value = <Subcategory>[];

//     subcategoryListFiltered.value =
//         subcategoryList.where((i) => i.categoryId == categoryId).toList().obs;

//     subcategoryListFiltered
//         .add(Subcategory(id: '', name: 'select subcategory', categoryId: ''));

//     var fggv = subcategoryListFiltered.reversed;
//     subcategoryListFiltered.value = fggv.toList();
//   }