Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 74365C77B78
	for <mm-commits@archiver.kernel.org>; Tue,  2 May 2023 20:44:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229574AbjEBUo5 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 2 May 2023 16:44:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36042 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229481AbjEBUo5 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 2 May 2023 16:44:57 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7569E1734
        for <mm-commits@vger.kernel.org>; Tue,  2 May 2023 13:44:55 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0F63E619C6
        for <mm-commits@vger.kernel.org>; Tue,  2 May 2023 20:44:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5AD4AC433EF;
        Tue,  2 May 2023 20:44:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1683060294;
        bh=MSlchaVOjYqjkVbN9he9Q9jXSSNRVe+5KfIupsfNzvA=;
        h=Date:To:From:Subject:From;
        b=asTRDnjtV7EKJRgwe9hYrCl6W7YooF7Kfw+qhvlOlAstaxGZDBbkjht65OoJaX4AS
         40JSZw7SCY+rJuaL9IQsFtGXiqOSfvcUCYekXav3FiaSBj03wHcW3twlGzu5rOqx64
         z6oWInq097K8gtl5cr+KG/Gn4nylScBmIb7GWSj4=
Date:   Tue, 02 May 2023 13:44:53 -0700
To:     mm-commits@vger.kernel.org, colin.i.king@gmail.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + scripts-spellingtxt-add-more-spellings-to-spellingtxt.patch added to mm-nonmm-unstable branch
Message-Id: <20230502204454.5AD4AC433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: scripts/spelling.txt: add more spellings to spelling.txt
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     scripts-spellingtxt-add-more-spellings-to-spellingtxt.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/scripts-spellingtxt-add-more-spellings-to-spellingtxt.patch

This patch will later appear in the mm-nonmm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

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

scripts-spellingtxt-add-more-spellings-to-spellingtxt.patch

