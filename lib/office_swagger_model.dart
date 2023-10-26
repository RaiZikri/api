class OfficeSwaggerModel {
   final String id1;
   final String id2;
   final String name;
   final String email;
   final String address;
   final String gender;
   final String birthday;
   final String profpic;

   OfficeSwaggerModel({
      required this.id1,
      required this.id2,
      required this.name,
      required this.email,
      required this.address,
      required this.gender,
      required this.birthday,
      required this.profpic
   });

   factory OfficeSwaggerModel.fromJson(Map<String, dynamic> data) {
      return OfficeSwaggerModel(
         id1: data['_id'],
         id2: data['id'],
         name: data['name'],
         email: data['email'],
         address: data['address'],
         gender: data['gender'],
         birthday: data['birthday'],
         profpic: data['profpic']
      );
   }
}