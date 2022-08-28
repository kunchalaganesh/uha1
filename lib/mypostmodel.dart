class mypostmodel{
  late String date;
  late String distance;
  late String ground;
  late String id;
  late String lattitude;
  late String longitude;
  late String main1;
  late String main1height;
  late String main2;
  late String main2height;
  late String nimage;
  late String obv;
  late String owner;
  late String posteddate;

  mypostmodel(
      this.date,
      this.distance,
      this.ground,
      this.id,
      this.lattitude,
      this.longitude,
      this.main1,
      this.main1height,
      this.main2,
      this.main2height,
      this.nimage,
      this.obv,
      this.owner,
      this.posteddate);

  mypostmodel.name(
      this.date,
      this.distance,
      this.ground,
      this.id,
      this.lattitude,
      this.longitude,
      this.main1,
      this.main1height,
      this.main2,
      this.main2height,
      this.nimage,
      this.obv,
      this.owner,
      this.posteddate);


  mypostmodel.fromJson(Map<String, String>json){
    date : json[''];
    distance : json[''];
    ground : json[''];
    id : json[''];
    lattitude : json[''];
    longitude : json[''];
    main1 : json[''];
    main1height : json[''];
    main2  : json[''];
    main2height : json[''];
    nimage : json[''];
    obv : json[''];
    owner : json [''];
    posteddate : json[''];

  }




}