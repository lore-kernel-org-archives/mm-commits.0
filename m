Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C1408C7EE2F
	for <mm-commits@archiver.kernel.org>; Sat, 10 Jun 2023 00:45:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229470AbjFJApG (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 9 Jun 2023 20:45:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50964 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229827AbjFJApF (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 9 Jun 2023 20:45:05 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6E30D30F6
        for <mm-commits@vger.kernel.org>; Fri,  9 Jun 2023 17:45:04 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0A50960FDC
        for <mm-commits@vger.kernel.org>; Sat, 10 Jun 2023 00:45:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6228EC433EF;
        Sat, 10 Jun 2023 00:45:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1686357903;
        bh=4J+negWu+f1EP1PaSX3whtj1PVSu4X+k19K8D0d9EdQ=;
        h=Date:To:From:Subject:From;
        b=HNAhO1PdIs6/IkCUWVBUiiHZUUL6to47RYYzCVRBat7XaLRI1QbC870J7KwsxyWLU
         SwzZGjVde6VjpmP7Ae9LmTVQWeiLJsls0QQtz1B0cqljdZOVZLh/qyWcdGQos1G0js
         5VoJNeZj8+HUrI1d3tfuI7fQkSxdpYR9GqFEHQec=
Date:   Fri, 09 Jun 2023 17:45:02 -0700
To:     mm-commits@vger.kernel.org, colin.i.king@gmail.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] scripts-spellingtxt-add-more-spellings-to-spellingtxt.patch removed from -mm tree
Message-Id: <20230610004503.6228EC433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: scripts/spelling.txt: add more spellings to spelling.txt
has been removed from the -mm tree.  Its filename was
     scripts-spellingtxt-add-more-spellings-to-spellingtxt.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Colin Ian King <colin.i.king@gmail.com>
Subject: scripts/spelling.txt: add more spellings to spelling.txt
Date: Thu, 27 Apr 2023 11:28:35 +0100

Some of the more common spelling mistakes and typos that I've found while
fixing up spelling mistakes in the kernel over the past couple of
releases.

Link: https://lkml.kernel.org/r/20230427102835.83482-1-colin.i.king@gmail.com
Signed-off-by: Colin Ian King <colin.i.king@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/spelling.txt |   22 ++++++++++++++++++++++
 1 file changed, 22 insertions(+)

--- a/scripts/spelling.txt~scripts-spellingtxt-add-more-spellings-to-spellingtxt
+++ a/scripts/spelling.txt
@@ -155,6 +155,7 @@ aquired||acquired
 aquisition||acquisition
 arbitary||arbitrary
 architechture||architecture
+archtecture||architecture
 arguement||argument
 arguements||arguments
 arithmatic||arithmetic
@@ -279,6 +280,7 @@ cant'||can't
 canot||cannot
 cann't||can't
 cannnot||cannot
+capabiity||capability
 capabilites||capabilities
 capabilties||capabilities
 capabilty||capability
@@ -426,6 +428,7 @@ cotrol||control
 cound||could
 couter||counter
 coutner||counter
+creationg||creating
 cryptocraphic||cryptographic
 cummulative||cumulative
 cunter||counter
@@ -492,6 +495,7 @@ destorys||destroys
 destroied||destroyed
 detabase||database
 deteced||detected
+detecion||detection
 detectt||detect
 detroyed||destroyed
 develope||develop
@@ -513,6 +517,7 @@ diferent||different
 differrence||difference
 diffrent||different
 differenciate||differentiate
+diffreential||differential
 diffrentiate||differentiate
 difinition||definition
 digial||digital
@@ -617,6 +622,7 @@ evalute||evaluate
 evalutes||evaluates
 evalution||evaluation
 excecutable||executable
+excceed||exceed
 exceded||exceeded
 exceds||exceeds
 exceeed||exceed
@@ -632,6 +638,7 @@ existant||existent
 exixt||exist
 exsits||exists
 exlcude||exclude
+exlcuding||excluding
 exlcusive||exclusive
 exlusive||exclusive
 exmaple||example
@@ -726,6 +733,8 @@ generiously||generously
 genereate||generate
 genereted||generated
 genric||generic
+gerenal||general
+geting||getting
 globel||global
 grabing||grabbing
 grahical||graphical
@@ -899,6 +908,7 @@ iteraions||iterations
 iternations||iterations
 itertation||iteration
 itslef||itself
+ivalid||invalid
 jave||java
 jeffies||jiffies
 jumpimng||jumping
@@ -977,6 +987,7 @@ microprocesspr||microprocessor
 migrateable||migratable
 millenium||millennium
 milliseonds||milliseconds
+minimim||minimum
 minium||minimum
 minimam||minimum
 minimun||minimum
@@ -1042,6 +1053,7 @@ notifed||notified
 notity||notify
 nubmer||number
 numebr||number
+numer||number
 numner||number
 nunber||number
 obtaion||obtain
@@ -1061,6 +1073,7 @@ offet||offset
 offlaod||offload
 offloded||offloaded
 offseting||offsetting
+oflload||offload
 omited||omitted
 omiting||omitting
 omitt||omit
@@ -1105,6 +1118,7 @@ pakage||package
 paket||packet
 pallette||palette
 paln||plan
+palne||plane
 paramameters||parameters
 paramaters||parameters
 paramater||parameter
@@ -1181,12 +1195,14 @@ previsously||previously
 primative||primitive
 princliple||principle
 priorty||priority
+priting||printing
 privilaged||privileged
 privilage||privilege
 priviledge||privilege
 priviledges||privileges
 privleges||privileges
 probaly||probably
+probabalistic||probabilistic
 procceed||proceed
 proccesors||processors
 procesed||processed
@@ -1460,6 +1476,7 @@ submited||submitted
 submition||submission
 succeded||succeeded
 suceed||succeed
+succesfuly||successfully
 succesfully||successfully
 succesful||successful
 successed||succeeded
@@ -1503,6 +1520,7 @@ symetric||symmetric
 synax||syntax
 synchonized||synchronized
 sychronization||synchronization
+sychronously||synchronously
 synchronuously||synchronously
 syncronize||synchronize
 syncronized||synchronized
@@ -1532,6 +1550,7 @@ threee||three
 threshhold||threshold
 thresold||threshold
 throught||through
+tansition||transition
 trackling||tracking
 troughput||throughput
 trys||tries
@@ -1611,6 +1630,7 @@ unneccessary||unnecessary
 unnecesary||unnecessary
 unneedingly||unnecessarily
 unnsupported||unsupported
+unuspported||unsupported
 unmached||unmatched
 unprecise||imprecise
 unpriviledged||unprivileged
@@ -1657,6 +1677,7 @@ verfication||verification
 veriosn||version
 verisons||versions
 verison||version
+veritical||vertical
 verson||version
 vicefersa||vice-versa
 virtal||virtual
@@ -1677,6 +1698,7 @@ whenver||whenever
 wheter||whether
 whe||when
 wierd||weird
+wihout||without
 wiil||will
 wirte||write
 withing||within
_

Patches currently in -mm which might be from colin.i.king@gmail.com are


