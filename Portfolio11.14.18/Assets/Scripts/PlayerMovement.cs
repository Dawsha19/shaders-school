using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class PlayerMovement : MonoBehaviour {

    public float moveSpeed;

	// Use this for initialization
	void Start () {
        moveSpeed = 5.0f;
	}
	
	// Update is called once per frame
	void Update () {
//        transform.Translate(moveSpeed * Input.GetAxis("Horizontal") * Time.deltaTime, 0f, moveSpeed * Input.GetAxis("Vertical") * Time.deltaTime);
        Vector3 posOffset = new Vector3(Input.GetAxis("Horizontal"), 0f, Input.GetAxis("Vertical"))*moveSpeed* Time.deltaTime;
        transform.position += posOffset;
	}
}
