From: akpm@linux-foundation.org
Subject: [merged] add-some-typo-words-in-patch-into-spellingtxt.patch
 removed from -mm tree
Date: Tue, 08 Sep 2015 11:01:52 -0700
Message-ID: <55ef2290.ci18jXK/edN6q9Di%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:58723 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754664AbbIHSBw (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 Sep 2015 14:01:52 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: zhaolei@cn.fujitsu.com, mm-commits@vger.kernel.org


The patch titled
     Subject: scripts/spelling.txt: add some typo-words
has been removed from the -mm tree.  Its filename was
     add-some-typo-words-in-patch-into-spellingtxt.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Zhao Lei <zhaolei@cn.fujitsu.com>
Subject: scripts/spelling.txt: add some typo-words

I write a small script to show word-pair from all linux spelling-typo
commits, and get following result by sort | uniq -c:

    181 occured -> occurred
     78 transfered -> transferred
     67 recieved -> received
     65 dependant -> dependent
     58 wether -> whether
     56 accomodate -> accommodate
     54 occured -> occurred
     51 recieve -> receive
     47 cant -> can't
     40 sucessfully -> successfully
     ...

Some of them are not in spelling.txt, this patch adds the most common
word-pairs into spelling.txt.

Signed-off-by: Zhao Lei <zhaolei@cn.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/spelling.txt |   24 ++++++++++++++++++++++++
 1 file changed, 24 insertions(+)

diff -puN scripts/spelling.txt~add-some-typo-words-in-patch-into-spellingtxt scripts/spelling.txt
--- a/scripts/spelling.txt~add-some-typo-words-in-patch-into-spellingtxt
+++ a/scripts/spelling.txt
@@ -32,6 +32,7 @@ accoring||according
 accout||account
 accquire||acquire
 accquired||acquired
+accross||across
 acessable||accessible
 acess||access
 achitecture||architecture
@@ -100,8 +101,10 @@ appropiate||appropriate
 appropriatly||appropriately
 approriate||appropriate
 approriately||appropriately
+apropriate||appropriate
 aquainted||acquainted
 aquired||acquired
+aquisition||acquisition
 arbitary||arbitrary
 architechture||architecture
 arguement||argument
@@ -111,6 +114,8 @@ arne't||aren't
 arraival||arrival
 artifical||artificial
 artillary||artillery
+asign||assign
+assertation||assertion
 assiged||assigned
 assigment||assignment
 assigments||assignments
@@ -136,6 +141,7 @@ automatize||automate
 automatized||automated
 automatizes||automates
 autonymous||autonomous
+auxillary||auxiliary
 auxilliary||auxiliary
 avaiable||available
 avaible||available
@@ -234,6 +240,8 @@ compatability||compatibility
 compatable||compatible
 compatibiliy||compatibility
 compatibilty||compatibility
+compatiblity||compatibility
+competion||completion
 compilant||compliant
 compleatly||completely
 completly||completely
@@ -294,6 +302,7 @@ defferred||deferred
 definate||definite
 definately||definitely
 defintion||definition
+defintions||definitions
 defualt||default
 defult||default
 deivce||device
@@ -309,6 +318,7 @@ depreacted||deprecated
 depreacte||deprecate
 desactivate||deactivate
 desciptors||descriptors
+descripton||description
 descrition||description
 descritptor||descriptor
 desctiptor||descriptor
@@ -330,6 +340,7 @@ devided||divided
 deviece||device
 diable||disable
 dictionnary||dictionary
+didnt||didn't
 diferent||different
 differrence||difference
 difinition||definition
@@ -347,6 +358,7 @@ docuentation||documentation
 documantation||documentation
 documentaion||documentation
 documment||document
+doesnt||doesn't
 dorp||drop
 dosen||doesn
 downlad||download
@@ -453,11 +465,13 @@ grahical||graphical
 grahpical||graphical
 grapic||graphic
 guage||gauge
+guarenteed||guaranteed
 guarentee||guarantee
 halfs||halves
 hander||handler
 handfull||handful
 hanled||handled
+happend||happened
 harware||hardware
 heirarchically||hierarchically
 helpfull||helpful
@@ -515,6 +529,7 @@ initialzed||initialized
 initilization||initialization
 initilize||initialize
 inofficial||unofficial
+insititute||institute
 instal||install
 inteface||interface
 integreated||integrated
@@ -549,6 +564,7 @@ invididual||individual
 invokation||invocation
 invokations||invocations
 irrelevent||irrelevant
+isnt||isn't
 isssue||issue
 itslef||itself
 jave||java
@@ -561,6 +577,7 @@ langauage||language
 langauge||language
 langugage||language
 lauch||launch
+layed||laid
 leightweight||lightweight
 lengh||length
 lenght||length
@@ -717,6 +734,7 @@ preceeding||preceding
 preceed||precede
 precendence||precedence
 precission||precision
+preemptable||preemptible
 prefered||preferred
 prefferably||preferably
 premption||preemption
@@ -747,6 +765,7 @@ programers||programmers
 programm||program
 programms||programs
 progresss||progress
+promiscous||promiscuous
 promps||prompts
 pronnounced||pronounced
 prononciation||pronunciation
@@ -820,6 +839,7 @@ reseting||resetting
 resizeable||resizable
 resouces||resources
 resoures||resources
+responce||response
 ressizes||resizes
 ressource||resource
 ressources||resources
@@ -872,6 +892,7 @@ setts||sets
 settting||setting
 shotdown||shutdown
 shoud||should
+shouldnt||shouldn't
 shoule||should
 shrinked||shrunk
 siginificantly||significantly
@@ -916,9 +937,11 @@ straming||streaming
 struc||struct
 structres||structures
 stuct||struct
+stucture||structure
 sturcture||structure
 subdirectoires||subdirectories
 suble||subtle
+substract||subtract
 succesfully||successfully
 succesful||successful
 successfull||successful
@@ -1031,6 +1054,7 @@ virtiual||virtual
 visiters||visitors
 vitual||virtual
 wating||waiting
+wether||whether
 whataver||whatever
 whcih||which
 whenver||whenever
_

Patches currently in -mm which might be from zhaolei@cn.fujitsu.com are


