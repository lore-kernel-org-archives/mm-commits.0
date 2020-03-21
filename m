From: Andrew Morton <akpm@linux-foundation.org>
Subject: +
 scripts-spellingtxt-add-more-spellings-to-spellingtxt.patch added to -mm
 tree
Date: Sat, 21 Mar 2020 13:43:11 -0700
Message-ID: <20200321204311.PwC4YwHN_%akpm@linux-foundation.org>
References: <20200305222751.6d781a3f2802d79510941e4e@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:59134 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726366AbgCUUnM (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sat, 21 Mar 2020 16:43:12 -0400
In-Reply-To: <20200305222751.6d781a3f2802d79510941e4e@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: colin.king@canonical.com, joe@perches.com, mm-commits@vger.kernel.org


The patch titled
     Subject: scripts/spelling.txt: add more spellings to spelling.txt
has been added to the -mm tree.  Its filename is
     scripts-spellingtxt-add-more-spellings-to-spellingtxt.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/scripts-spellingtxt-add-more-spellings-to-spellingtxt.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/scripts-spellingtxt-add-more-spellings-to-spellingtxt.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Colin Ian King <colin.king@canonical.com>
Subject: scripts/spelling.txt: add more spellings to spelling.txt

Here are some of the more common spelling mistakes and typos that I've
found while fixing up spelling mistakes in the kernel since November 2019

Link: http://lkml.kernel.org/r/20200313174946.228216-1-colin.king@canonical.com
Signed-off-by: Colin Ian King <colin.king@canonical.com>
Cc: Joe Perches <joe@perches.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/spelling.txt |   20 +++++++++++++++++++-
 1 file changed, 19 insertions(+), 1 deletion(-)

--- a/scripts/spelling.txt~scripts-spellingtxt-add-more-spellings-to-spellingtxt
+++ a/scripts/spelling.txt
@@ -177,7 +177,9 @@ atomatically||automatically
 atomicly||atomically
 atempt||attempt
 attachement||attachment
+attatch||attach
 attched||attached
+attemp||attempt
 attemps||attempts
 attemping||attempting
 attepmpt||attempt
@@ -235,11 +237,13 @@ brievely||briefly
 brigde||bridge
 broadcase||broadcast
 broadcat||broadcast
+bufer||buffer
 bufufer||buffer
 cacluated||calculated
 caculate||calculate
 caculation||calculation
 cadidate||candidate
+cahces||caches
 calender||calendar
 calescing||coalescing
 calle||called
@@ -338,7 +342,6 @@ conditon||condition
 condtion||condition
 conected||connected
 conector||connector
-connecetd||connected
 configration||configuration
 configuartion||configuration
 configuation||configuration
@@ -349,7 +352,9 @@ configuretion||configuration
 configutation||configuration
 conider||consider
 conjuction||conjunction
+connecetd||connected
 connectinos||connections
+connetor||connector
 connnection||connection
 connnections||connections
 consistancy||consistency
@@ -469,6 +474,7 @@ difinition||definition
 digial||digital
 dimention||dimension
 dimesions||dimensions
+disgest||digest
 dispalying||displaying
 diplay||display
 directon||direction
@@ -553,6 +559,7 @@ etsablishment||establishment
 etsbalishment||establishment
 excecutable||executable
 exceded||exceeded
+exceeed||exceed
 excellant||excellent
 execeeded||exceeded
 execeeds||exceeds
@@ -742,6 +749,7 @@ initialzing||initializing
 initilization||initialization
 initilize||initialize
 initliaze||initialize
+initilized||initialized
 inofficial||unofficial
 inrerface||interface
 insititute||institute
@@ -802,6 +810,7 @@ irrelevent||irrelevant
 isnt||isn't
 isssue||issue
 issus||issues
+iteraions||iterations
 iternations||iterations
 itertation||iteration
 itslef||itself
@@ -828,6 +837,7 @@ libary||library
 librairies||libraries
 libraris||libraries
 licenceing||licencing
+limted||limited
 logaritmic||logarithmic
 loggging||logging
 loggin||login
@@ -924,6 +934,7 @@ nerver||never
 nescessary||necessary
 nessessary||necessary
 noticable||noticeable
+notication||notification
 notications||notifications
 notifcations||notifications
 notifed||notified
@@ -1007,6 +1018,7 @@ pendantic||pedantic
 peprocessor||preprocessor
 perfoming||performing
 perfomring||performing
+periperal||peripheral
 peripherial||peripheral
 permissons||permissions
 peroid||period
@@ -1043,6 +1055,7 @@ prefferably||preferably
 premption||preemption
 prepaired||prepared
 preperation||preparation
+preprare||prepare
 pressre||pressure
 primative||primitive
 princliple||principle
@@ -1064,6 +1077,7 @@ processsed||processed
 processsing||processing
 procteted||protected
 prodecure||procedure
+progamming||programming
 progams||programs
 progess||progress
 programers||programmers
@@ -1151,12 +1165,14 @@ replys||replies
 reponse||response
 representaion||representation
 reqeust||request
+reqister||register
 requestied||requested
 requiere||require
 requirment||requirement
 requred||required
 requried||required
 requst||request
+requsted||requested
 reregisteration||reregistration
 reseting||resetting
 reseved||reserved
@@ -1227,10 +1243,12 @@ seqeuncer||sequencer
 seqeuencer||sequencer
 sequece||sequence
 sequencial||sequential
+serivce||service
 serveral||several
 servive||service
 setts||sets
 settting||setting
+shapshot||snapshot
 shotdown||shutdown
 shoud||should
 shouldnt||shouldn't
_

Patches currently in -mm which might be from colin.king@canonical.com are

scripts-spellingtxt-add-more-spellings-to-spellingtxt.patch
mm-memblock-remove-redundant-assignment-to-variable-max_addr.patch
lib-test_lockup-fix-spelling-mistake-iteraions-iterations.patch
