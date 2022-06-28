class Student{
  final String? email;
  final String? firstname;
  final String? lastname;
  final String? matricNo;
  final String? img;

  Student({this.email, this.firstname, this.lastname, this.matricNo, this.img});

  factory Student.fromJson(Map<String, dynamic> json){
    return Student(
        email: json['email'],
        firstname: json['firstname'],
        lastname: json['lastname'],
        matricNo: json['matricNo'],
        img: json['img']
    );
  }

}