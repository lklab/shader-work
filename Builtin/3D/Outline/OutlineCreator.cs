using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class OutlineCreator : MonoBehaviour
{
    [SerializeField] private Material outlineMat;
    [SerializeField] private Transform tmpT;
    [SerializeField] private GameObject outlineObj;

    private void Awake()
    {
        outlineMat.hideFlags = HideFlags.HideAndDontSave;

        if (tmpT)
        {
            if (GetComponent<MeshFilter>())
            {
                outlineObj.GetComponent<MeshRenderer>().material = outlineMat;
            }
        }

        if (outlineObj == null)
        {
            outlineObj = new GameObject("Outline");
            outlineObj.transform.parent = transform;
            if (GetComponent<MeshFilter>())
            {
                outlineObj.AddComponent<MeshFilter>();
                outlineObj.AddComponent<MeshRenderer>();
                Mesh tmpMesh = (Mesh)Instantiate(GetComponent<MeshFilter>().sharedMesh);
                MeshNormalAverage.Create(tmpMesh);
                outlineObj.GetComponent<MeshFilter>().sharedMesh = tmpMesh;
                outlineObj.GetComponent<MeshRenderer>().material = outlineMat;
            }
        }

        outlineObj.transform.localPosition = Vector3.zero;
        outlineObj.transform.localRotation = Quaternion.identity;
        outlineObj.transform.localScale = Vector3.one;
    }
}
