List<String> labels=['apple', 'banana', 'blackgram', 'chickpea', 'coconut', 'coffee', 'cotton', 'grapes', 'jute', 'kidneybeans', 'lentil', 'maize', 'mango', 'mothbeans', 'mungbean', 'muskmelon', 'orange', 'papaya', 'pigeonpeas', 'pomegranate', 'rice', 'watermelon'];

class DecisionTreeClassifier {

  int findMax(List nums) {
    int index = 0;
    for (int i = 0; i < nums.length; i++) {
      index = nums[i] > nums[index] ? i : index;
    }
    return index;
  }

  Future<String> predict({required List features}) async{
  List<int> classes = [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0];

  for(var i=0;i<features.length;i++){
    features[i]=double.parse(features[i]);
  }

  if (features[4] <= 27.68508243560791) {
    if (features[2] <= 50.0) {
    classes[0] = 0;
    classes[1] = 0;
    classes[2] = 0;
    classes[3] = 0;
    classes[4] = 0;
    classes[5] = 0;
    classes[6] = 0;
    classes[7] = 0;
    classes[8] = 0;
    classes[9] = 94;
    classes[10] = 0;
    classes[11] = 0;
    classes[12] = 0;
    classes[13] = 0;
    classes[14] = 0;
    classes[15] = 0;
    classes[16] = 0;
    classes[17] = 0;
    classes[18] = 0;
    classes[19] = 0;
    classes[20] = 0;
    classes[21] = 0;
    }
    else {
  classes[0] = 0;
  classes[1] = 0;
  classes[2] = 0;
  classes[3] = 90;
  classes[4] = 0;
  classes[5] = 0;
  classes[6] = 0;
  classes[7] = 0;
  classes[8] = 0;
  classes[9] = 0;
  classes[10] = 0;
  classes[11] = 0;
  classes[12] = 0;
  classes[13] = 0;
  classes[14] = 0;
  classes[15] = 0;
  classes[16] = 0;
  classes[17] = 0;
  classes[18] = 0;
  classes[19] = 0;
  classes[20] = 0;
  classes[21] = 0;
  }
  }
  else {
  if (features[1] <= 107.5) {
  if (features[6] <= 30.39347743988037) {
  classes[0] = 0;
  classes[1] = 0;
  classes[2] = 0;
  classes[3] = 0;
  classes[4] = 0;
  classes[5] = 0;
  classes[6] = 0;
  classes[7] = 0;
  classes[8] = 0;
  classes[9] = 0;
  classes[10] = 0;
  classes[11] = 0;
  classes[12] = 0;
  classes[13] = 0;
  classes[14] = 0;
  classes[15] = 88;
  classes[16] = 0;
  classes[17] = 0;
  classes[18] = 0;
  classes[19] = 0;
  classes[20] = 0;
  classes[21] = 0;
  } else {
  if (features[4] <= 72.93193054199219) {
  if (features[0] <= 59.5) {
  if (features[6] <= 82.10353469848633) {
  if (features[1] <= 57.5) {
  if (features[4] <= 65.1456184387207) {
  if (features[0] <= 45.5) {
  if (features[3] <= 23.53550910949707) {
  classes[0] = 0;
  classes[1] = 0;
  classes[2] = 0;
  classes[3] = 0;
  classes[4] = 0;
  classes[5] = 0;
  classes[6] = 0;
  classes[7] = 0;
  classes[8] = 0;
  classes[9] = 0;
  classes[10] = 1;
  classes[11] = 0;
  classes[12] = 0;
  classes[13] = 0;
  classes[14] = 0;
  classes[15] = 0;
  classes[16] = 0;
  classes[17] = 0;
  classes[18] = 0;
  classes[19] = 0;
  classes[20] = 0;
  classes[21] = 0;
  } else {
  classes[0] = 0;
  classes[1] = 0;
  classes[2] = 0;
  classes[3] = 0;
  classes[4] = 0;
  classes[5] = 0;
  classes[6] = 0;
  classes[7] = 0;
  classes[8] = 0;
  classes[9] = 0;
  classes[10] = 0;
  classes[11] = 0;
  classes[12] = 0;
  classes[13] = 83;
  classes[14] = 0;
  classes[15] = 0;
  classes[16] = 0;
  classes[17] = 0;
  classes[18] = 0;
  classes[19] = 0;
  classes[20] = 0;
  classes[21] = 0;
  }
  } else {
  classes[0] = 0;
  classes[1] = 0;
  classes[2] = 2;
  classes[3] = 0;
  classes[4] = 0;
  classes[5] = 0;
  classes[6] = 0;
  classes[7] = 0;
  classes[8] = 0;
  classes[9] = 0;
  classes[10] = 0;
  classes[11] = 0;
  classes[12] = 0;
  classes[13] = 0;
  classes[14] = 0;
  classes[15] = 0;
  classes[16] = 0;
  classes[17] = 0;
  classes[18] = 0;
  classes[19] = 0;
  classes[20] = 0;
  classes[21] = 0;
  }
  } else {
  if (features[3] <= 28.40544319152832) {
  classes[0] = 0;
  classes[1] = 0;
  classes[2] = 0;
  classes[3] = 0;
  classes[4] = 0;
  classes[5] = 0;
  classes[6] = 0;
  classes[7] = 0;
  classes[8] = 0;
  classes[9] = 0;
  classes[10] = 2;
  classes[11] = 0;
  classes[12] = 0;
  classes[13] = 0;
  classes[14] = 0;
  classes[15] = 0;
  classes[16] = 0;
  classes[17] = 0;
  classes[18] = 0;
  classes[19] = 0;
  classes[20] = 0;
  classes[21] = 0;
  } else {
  classes[0] = 0;
  classes[1] = 0;
  classes[2] = 3;
  classes[3] = 0;
  classes[4] = 0;
  classes[5] = 0;
  classes[6] = 0;
  classes[7] = 0;
  classes[8] = 0;
  classes[9] = 0;
  classes[10] = 0;
  classes[11] = 0;
  classes[12] = 0;
  classes[13] = 0;
  classes[14] = 0;
  classes[15] = 0;
  classes[16] = 0;
  classes[17] = 0;
  classes[18] = 0;
  classes[19] = 0;
  classes[20] = 0;
  classes[21] = 0;
  }
  }
  } else {
  if (features[6] <= 59.80371856689453) {
  if (features[4] <= 60.17880439758301) {
  if (features[1] <= 60.5) {
  classes[0] = 0;
  classes[1] = 0;
  classes[2] = 0;
  classes[3] = 0;
  classes[4] = 0;
  classes[5] = 0;
  classes[6] = 0;
  classes[7] = 0;
  classes[8] = 0;
  classes[9] = 0;
  classes[10] = 0;
  classes[11] = 0;
  classes[12] = 0;
  classes[13] = 9;
  classes[14] = 0;
  classes[15] = 0;
  classes[16] = 0;
  classes[17] = 0;
  classes[18] = 0;
  classes[19] = 0;
  classes[20] = 0;
  classes[21] = 0;
  } else {
  classes[0] = 0;
  classes[1] = 0;
  classes[2] = 0;
  classes[3] = 0;
  classes[4] = 0;
  classes[5] = 0;
  classes[6] = 0;
  classes[7] = 0;
  classes[8] = 0;
  classes[9] = 0;
  classes[10] = 1;
  classes[11] = 0;
  classes[12] = 0;
  classes[13] = 0;
  classes[14] = 0;
  classes[15] = 0;
  classes[16] = 0;
  classes[17] = 0;
  classes[18] = 0;
  classes[19] = 0;
  classes[20] = 0;
  classes[21] = 0;
  }
  } else {
  classes[0] = 0;
  classes[1] = 0;
  classes[2] = 0;
  classes[3] = 0;
  classes[4] = 0;
  classes[5] = 0;
  classes[6] = 0;
  classes[7] = 0;
  classes[8] = 0;
  classes[9] = 0;
  classes[10] = 89;
  classes[11] = 0;
  classes[12] = 0;
  classes[13] = 0;
  classes[14] = 0;
  classes[15] = 0;
  classes[16] = 0;
  classes[17] = 0;
  classes[18] = 0;
  classes[19] = 0;
  classes[20] = 0;
  classes[21] = 0;
  }
  } else {
  if (features[5] <= 6.388936758041382) {
  classes[0] = 0;
  classes[1] = 0;
  classes[2] = 0;
  classes[3] = 0;
  classes[4] = 0;
  classes[5] = 0;
  classes[6] = 0;
  classes[7] = 0;
  classes[8] = 0;
  classes[9] = 0;
  classes[10] = 0;
  classes[11] = 0;
  classes[12] = 0;
  classes[13] = 1;
  classes[14] = 0;
  classes[15] = 0;
  classes[16] = 0;
  classes[17] = 0;
  classes[18] = 0;
  classes[19] = 0;
  classes[20] = 0;
  classes[21] = 0;
  } else {
  classes[0] = 0;
  classes[1] = 0;
  classes[2] = 87;
  classes[3] = 0;
  classes[4] = 0;
  classes[5] = 0;
  classes[6] = 0;
  classes[7] = 0;
  classes[8] = 0;
  classes[9] = 0;
  classes[10] = 0;
  classes[11] = 0;
  classes[12] = 0;
  classes[13] = 0;
  classes[14] = 0;
  classes[15] = 0;
  classes[16] = 0;
  classes[17] = 0;
  classes[18] = 0;
  classes[19] = 0;
  classes[20] = 0;
  classes[21] = 0;
  }
  }
  }
  } else {
  if (features[1] <= 47.5) {
  classes[0] = 0;
  classes[1] = 0;
  classes[2] = 0;
  classes[3] = 0;
  classes[4] = 0;
  classes[5] = 0;
  classes[6] = 0;
  classes[7] = 0;
  classes[8] = 0;
  classes[9] = 0;
  classes[10] = 0;
  classes[11] = 0;
  classes[12] = 88;
  classes[13] = 0;
  classes[14] = 0;
  classes[15] = 0;
  classes[16] = 0;
  classes[17] = 0;
  classes[18] = 0;
  classes[19] = 0;
  classes[20] = 0;
  classes[21] = 0;
  } else {
  classes[0] = 0;
  classes[1] = 0;
  classes[2] = 0;
  classes[3] = 0;
  classes[4] = 0;
  classes[5] = 0;
  classes[6] = 0;
  classes[7] = 0;
  classes[8] = 0;
  classes[9] = 0;
  classes[10] = 0;
  classes[11] = 0;
  classes[12] = 0;
  classes[13] = 0;
  classes[14] = 0;
  classes[15] = 0;
  classes[16] = 0;
  classes[17] = 0;
  classes[18] = 91;
  classes[19] = 0;
  classes[20] = 0;
  classes[21] = 0;
  }
  }
  } else {
  if (features[6] <= 112.18631362915039) {
  if (features[5] <= 7.093683242797852) {
  classes[0] = 0;
  classes[1] = 0;
  classes[2] = 0;
  classes[3] = 0;
  classes[4] = 0;
  classes[5] = 0;
  classes[6] = 0;
  classes[7] = 0;
  classes[8] = 0;
  classes[9] = 0;
  classes[10] = 0;
  classes[11] = 84;
  classes[12] = 0;
  classes[13] = 0;
  classes[14] = 0;
  classes[15] = 0;
  classes[16] = 0;
  classes[17] = 0;
  classes[18] = 0;
  classes[19] = 0;
  classes[20] = 0;
  classes[21] = 0;
  } else {
  classes[0] = 0;
  classes[1] = 0;
  classes[2] = 1;
  classes[3] = 0;
  classes[4] = 0;
  classes[5] = 0;
  classes[6] = 0;
  classes[7] = 0;
  classes[8] = 0;
  classes[9] = 0;
  classes[10] = 0;
  classes[11] = 0;
  classes[12] = 0;
  classes[13] = 0;
  classes[14] = 0;
  classes[15] = 0;
  classes[16] = 0;
  classes[17] = 0;
  classes[18] = 0;
  classes[19] = 0;
  classes[20] = 0;
  classes[21] = 0;
  }
  } else {
  if (features[4] <= 70.41533660888672) {
  classes[0] = 0;
  classes[1] = 0;
  classes[2] = 0;
  classes[3] = 0;
  classes[4] = 0;
  classes[5] = 89;
  classes[6] = 0;
  classes[7] = 0;
  classes[8] = 0;
  classes[9] = 0;
  classes[10] = 0;
  classes[11] = 0;
  classes[12] = 0;
  classes[13] = 0;
  classes[14] = 0;
  classes[15] = 0;
  classes[16] = 0;
  classes[17] = 0;
  classes[18] = 0;
  classes[19] = 0;
  classes[20] = 0;
  classes[21] = 0;
  } else {
  classes[0] = 0;
  classes[1] = 0;
  classes[2] = 0;
  classes[3] = 0;
  classes[4] = 0;
  classes[5] = 0;
  classes[6] = 0;
  classes[7] = 0;
  classes[8] = 10;
  classes[9] = 0;
  classes[10] = 0;
  classes[11] = 0;
  classes[12] = 0;
  classes[13] = 0;
  classes[14] = 0;
  classes[15] = 0;
  classes[16] = 0;
  classes[17] = 0;
  classes[18] = 0;
  classes[19] = 0;
  classes[20] = 0;
  classes[21] = 0;
  }
  }
  }
  } else {
  if (features[1] <= 32.5) {
  if (features[6] <= 79.96679878234863) {
  classes[0] = 0;
  classes[1] = 0;
  classes[2] = 0;
  classes[3] = 0;
  classes[4] = 0;
  classes[5] = 0;
  classes[6] = 0;
  classes[7] = 0;
  classes[8] = 0;
  classes[9] = 0;
  classes[10] = 0;
  classes[11] = 0;
  classes[12] = 0;
  classes[13] = 0;
  classes[14] = 0;
  classes[15] = 0;
  classes[16] = 0;
  classes[17] = 0;
  classes[18] = 0;
  classes[19] = 0;
  classes[20] = 0;
  classes[21] = 92;
  } else {
  if (features[6] <= 125.392333984375) {
  if (features[2] <= 25.0) {
  classes[0] = 0;
  classes[1] = 0;
  classes[2] = 0;
  classes[3] = 0;
  classes[4] = 0;
  classes[5] = 0;
  classes[6] = 0;
  classes[7] = 0;
  classes[8] = 0;
  classes[9] = 0;
  classes[10] = 0;
  classes[11] = 0;
  classes[12] = 0;
  classes[13] = 0;
  classes[14] = 0;
  classes[15] = 0;
  classes[16] = 85;
  classes[17] = 0;
  classes[18] = 0;
  classes[19] = 0;
  classes[20] = 0;
  classes[21] = 0;
  } else {
  classes[0] = 0;
  classes[1] = 0;
  classes[2] = 0;
  classes[3] = 0;
  classes[4] = 0;
  classes[5] = 0;
  classes[6] = 0;
  classes[7] = 0;
  classes[8] = 0;
  classes[9] = 0;
  classes[10] = 0;
  classes[11] = 0;
  classes[12] = 0;
  classes[13] = 0;
  classes[14] = 0;
  classes[15] = 0;
  classes[16] = 0;
  classes[17] = 0;
  classes[18] = 0;
  classes[19] = 88;
  classes[20] = 0;
  classes[21] = 0;
  }
  } else {
  classes[0] = 0;
  classes[1] = 0;
  classes[2] = 0;
  classes[3] = 0;
  classes[4] = 89;
  classes[5] = 0;
  classes[6] = 0;
  classes[7] = 0;
  classes[8] = 0;
  classes[9] = 0;
  classes[10] = 0;
  classes[11] = 0;
  classes[12] = 0;
  classes[13] = 0;
  classes[14] = 0;
  classes[15] = 0;
  classes[16] = 0;
  classes[17] = 0;
  classes[18] = 0;
  classes[19] = 0;
  classes[20] = 0;
  classes[21] = 0;
  }
  }
  } else {
  if (features[4] <= 90.01739120483398) {
  if (features[1] <= 65.0) {
  if (features[0] <= 99.5) {
  if (features[6] <= 69.80655288696289) {
  classes[0] = 0;
  classes[1] = 0;
  classes[2] = 0;
  classes[3] = 0;
  classes[4] = 0;
  classes[5] = 0;
  classes[6] = 0;
  classes[7] = 0;
  classes[8] = 0;
  classes[9] = 0;
  classes[10] = 0;
  classes[11] = 0;
  classes[12] = 0;
  classes[13] = 0;
  classes[14] = 85;
  classes[15] = 0;
  classes[16] = 0;
  classes[17] = 0;
  classes[18] = 0;
  classes[19] = 0;
  classes[20] = 0;
  classes[21] = 0;
  } else {
  if (features[6] <= 199.9622802734375) {
  if (features[5] <= 6.007270574569702) {
  if (features[4] <= 76.89459228515625) {
  classes[0] = 0;
  classes[1] = 0;
  classes[2] = 0;
  classes[3] = 0;
  classes[4] = 0;
  classes[5] = 0;
  classes[6] = 0;
  classes[7] = 0;
  classes[8] = 0;
  classes[9] = 0;
  classes[10] = 0;
  classes[11] = 1;
  classes[12] = 0;
  classes[13] = 0;
  classes[14] = 0;
  classes[15] = 0;
  classes[16] = 0;
  classes[17] = 0;
  classes[18] = 0;
  classes[19] = 0;
  classes[20] = 0;
  classes[21] = 0;
  } else {
  classes[0] = 0;
  classes[1] = 0;
  classes[2] = 0;
  classes[3] = 0;
  classes[4] = 0;
  classes[5] = 0;
  classes[6] = 0;
  classes[7] = 0;
  classes[8] = 0;
  classes[9] = 0;
  classes[10] = 0;
  classes[11] = 0;
  classes[12] = 0;
  classes[13] = 0;
  classes[14] = 0;
  classes[15] = 0;
  classes[16] = 0;
  classes[17] = 0;
  classes[18] = 0;
  classes[19] = 0;
  classes[20] = 8;
  classes[21] = 0;
  }
  } else {
  if (features[6] <= 128.8643569946289) {
  classes[0] = 0;
  classes[1] = 0;
  classes[2] = 0;
  classes[3] = 0;
  classes[4] = 0;
  classes[5] = 0;
  classes[6] = 0;
  classes[7] = 0;
  classes[8] = 0;
  classes[9] = 0;
  classes[10] = 0;
  classes[11] = 5;
  classes[12] = 0;
  classes[13] = 0;
  classes[14] = 0;
  classes[15] = 0;
  classes[16] = 0;
  classes[17] = 0;
  classes[18] = 0;
  classes[19] = 0;
  classes[20] = 0;
  classes[21] = 0;
  } else {
  if (features[3] <= 22.88876438140869) {
  classes[0] = 0;
  classes[1] = 0;
  classes[2] = 0;
  classes[3] = 0;
  classes[4] = 0;
  classes[5] = 0;
  classes[6] = 0;
  classes[7] = 0;
  classes[8] = 0;
  classes[9] = 0;
  classes[10] = 0;
  classes[11] = 0;
  classes[12] = 0;
  classes[13] = 0;
  classes[14] = 0;
  classes[15] = 0;
  classes[16] = 0;
  classes[17] = 0;
  classes[18] = 0;
  classes[19] = 0;
  classes[20] = 5;
  classes[21] = 0;
  } else {
  if (features[0] <= 90.5) {
  if (features[1] <= 36.5) {
  if (features[6] <= 180.07454681396484) {
  classes[0] = 0;
  classes[1] = 0;
  classes[2] = 0;
  classes[3] = 0;
  classes[4] = 0;
  classes[5] = 0;
  classes[6] = 0;
  classes[7] = 0;
  classes[8] = 4;
  classes[9] = 0;
  classes[10] = 0;
  classes[11] = 0;
  classes[12] = 0;
  classes[13] = 0;
  classes[14] = 0;
  classes[15] = 0;
  classes[16] = 0;
  classes[17] = 0;
  classes[18] = 0;
  classes[19] = 0;
  classes[20] = 0;
  classes[21] = 0;
  } else {
  classes[0] = 0;
  classes[1] = 0;
  classes[2] = 0;
  classes[3] = 0;
  classes[4] = 0;
  classes[5] = 0;
  classes[6] = 0;
  classes[7] = 0;
  classes[8] = 0;
  classes[9] = 0;
  classes[10] = 0;
  classes[11] = 0;
  classes[12] = 0;
  classes[13] = 0;
  classes[14] = 0;
  classes[15] = 0;
  classes[16] = 0;
  classes[17] = 0;
  classes[18] = 0;
  classes[19] = 0;
  classes[20] = 2;
  classes[21] = 0;
  }
  } else {
  classes[0] = 0;
  classes[1] = 0;
  classes[2] = 0;
  classes[3] = 0;
  classes[4] = 0;
  classes[5] = 0;
  classes[6] = 0;
  classes[7] = 0;
  classes[8] = 65;
  classes[9] = 0;
  classes[10] = 0;
  classes[11] = 0;
  classes[12] = 0;
  classes[13] = 0;
  classes[14] = 0;
  classes[15] = 0;
  classes[16] = 0;
  classes[17] = 0;
  classes[18] = 0;
  classes[19] = 0;
  classes[20] = 0;
  classes[21] = 0;
  }
  } else {
  if (features[6] <= 180.86235809326172) {
  classes[0] = 0;
  classes[1] = 0;
  classes[2] = 0;
  classes[3] = 0;
  classes[4] = 0;
  classes[5] = 0;
  classes[6] = 0;
  classes[7] = 0;
  classes[8] = 3;
  classes[9] = 0;
  classes[10] = 0;
  classes[11] = 0;
  classes[12] = 0;
  classes[13] = 0;
  classes[14] = 0;
  classes[15] = 0;
  classes[16] = 0;
  classes[17] = 0;
  classes[18] = 0;
  classes[19] = 0;
  classes[20] = 0;
  classes[21] = 0;
  } else {
  if (features[4] <= 78.48317337036133) {
  classes[0] = 0;
  classes[1] = 0;
  classes[2] = 0;
  classes[3] = 0;
  classes[4] = 0;
  classes[5] = 0;
  classes[6] = 0;
  classes[7] = 0;
  classes[8] = 2;
  classes[9] = 0;
  classes[10] = 0;
  classes[11] = 0;
  classes[12] = 0;
  classes[13] = 0;
  classes[14] = 0;
  classes[15] = 0;
  classes[16] = 0;
  classes[17] = 0;
  classes[18] = 0;
  classes[19] = 0;
  classes[20] = 0;
  classes[21] = 0;
  } else {
  if (features[4] <= 82.97732925415039) {
  classes[0] = 0;
  classes[1] = 0;
  classes[2] = 0;
  classes[3] = 0;
  classes[4] = 0;
  classes[5] = 0;
  classes[6] = 0;
  classes[7] = 0;
  classes[8] = 0;
  classes[9] = 0;
  classes[10] = 0;
  classes[11] = 0;
  classes[12] = 0;
  classes[13] = 0;
  classes[14] = 0;
  classes[15] = 0;
  classes[16] = 0;
  classes[17] = 0;
  classes[18] = 0;
  classes[19] = 0;
  classes[20] = 4;
  classes[21] = 0;
  } else {
  classes[0] = 0;
  classes[1] = 0;
  classes[2] = 0;
  classes[3] = 0;
  classes[4] = 0;
  classes[5] = 0;
  classes[6] = 0;
  classes[7] = 0;
  classes[8] = 1;
  classes[9] = 0;
  classes[10] = 0;
  classes[11] = 0;
  classes[12] = 0;
  classes[13] = 0;
  classes[14] = 0;
  classes[15] = 0;
  classes[16] = 0;
  classes[17] = 0;
  classes[18] = 0;
  classes[19] = 0;
  classes[20] = 0;
  classes[21] = 0;
  }
  }
  }
  }
  }
  }
  }
  } else {
  classes[0] = 0;
  classes[1] = 0;
  classes[2] = 0;
  classes[3] = 0;
  classes[4] = 0;
  classes[5] = 0;
  classes[6] = 0;
  classes[7] = 0;
  classes[8] = 0;
  classes[9] = 0;
  classes[10] = 0;
  classes[11] = 0;
  classes[12] = 0;
  classes[13] = 0;
  classes[14] = 0;
  classes[15] = 0;
  classes[16] = 0;
  classes[17] = 0;
  classes[18] = 0;
  classes[19] = 0;
  classes[20] = 73;
  classes[21] = 0;
  }
  }
  } else {
  if (features[6] <= 130.27637100219727) {
  classes[0] = 0;
  classes[1] = 0;
  classes[2] = 0;
  classes[3] = 0;
  classes[4] = 0;
  classes[5] = 0;
  classes[6] = 89;
  classes[7] = 0;
  classes[8] = 0;
  classes[9] = 0;
  classes[10] = 0;
  classes[11] = 0;
  classes[12] = 0;
  classes[13] = 0;
  classes[14] = 0;
  classes[15] = 0;
  classes[16] = 0;
  classes[17] = 0;
  classes[18] = 0;
  classes[19] = 0;
  classes[20] = 0;
  classes[21] = 0;
  } else {
  classes[0] = 0;
  classes[1] = 0;
  classes[2] = 0;
  classes[3] = 0;
  classes[4] = 0;
  classes[5] = 0;
  classes[6] = 0;
  classes[7] = 0;
  classes[8] = 2;
  classes[9] = 0;
  classes[10] = 0;
  classes[11] = 0;
  classes[12] = 0;
  classes[13] = 0;
  classes[14] = 0;
  classes[15] = 0;
  classes[16] = 0;
  classes[17] = 0;
  classes[18] = 0;
  classes[19] = 0;
  classes[20] = 0;
  classes[21] = 0;
  }
  }
  } else {
  classes[0] = 0;
  classes[1] = 87;
  classes[2] = 0;
  classes[3] = 0;
  classes[4] = 0;
  classes[5] = 0;
  classes[6] = 0;
  classes[7] = 0;
  classes[8] = 0;
  classes[9] = 0;
  classes[10] = 0;
  classes[11] = 0;
  classes[12] = 0;
  classes[13] = 0;
  classes[14] = 0;
  classes[15] = 0;
  classes[16] = 0;
  classes[17] = 0;
  classes[18] = 0;
  classes[19] = 0;
  classes[20] = 0;
  classes[21] = 0;
  }
  } else {
  classes[0] = 0;
  classes[1] = 0;
  classes[2] = 0;
  classes[3] = 0;
  classes[4] = 0;
  classes[5] = 0;
  classes[6] = 0;
  classes[7] = 0;
  classes[8] = 0;
  classes[9] = 0;
  classes[10] = 0;
  classes[11] = 0;
  classes[12] = 0;
  classes[13] = 0;
  classes[14] = 0;
  classes[15] = 0;
  classes[16] = 0;
  classes[17] = 93;
  classes[18] = 0;
  classes[19] = 0;
  classes[20] = 0;
  classes[21] = 0;
  }
  }
  }
  }
  } else {
  if (features[4] <= 87.00463485717773) {
  classes[0] = 0;
  classes[1] = 0;
  classes[2] = 0;
  classes[3] = 0;
  classes[4] = 0;
  classes[5] = 0;
  classes[6] = 0;
  classes[7] = 92;
  classes[8] = 0;
  classes[9] = 0;
  classes[10] = 0;
  classes[11] = 0;
  classes[12] = 0;
  classes[13] = 0;
  classes[14] = 0;
  classes[15] = 0;
  classes[16] = 0;
  classes[17] = 0;
  classes[18] = 0;
  classes[19] = 0;
  classes[20] = 0;
  classes[21] = 0;
  } else {
  classes[0] = 92;
  classes[1] = 0;
  classes[2] = 0;
  classes[3] = 0;
  classes[4] = 0;
  classes[5] = 0;
  classes[6] = 0;
  classes[7] = 0;
  classes[8] = 0;
  classes[9] = 0;
  classes[10] = 0;
  classes[11] = 0;
  classes[12] = 0;
  classes[13] = 0;
  classes[14] = 0;
  classes[15] = 0;
  classes[16] = 0;
  classes[17] = 0;
  classes[18] = 0;
  classes[19] = 0;
  classes[20] = 0;
  classes[21] = 0;
  }
  }
  }

  return labels[findMax(classes)];
  }
}