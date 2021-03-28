Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1E455C433C1
	for <mm-commits@archiver.kernel.org>; Sun, 28 Mar 2021 19:12:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E204761958
	for <mm-commits@archiver.kernel.org>; Sun, 28 Mar 2021 19:12:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231580AbhC1TLo (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 28 Mar 2021 15:11:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:49872 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230395AbhC1TLd (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sun, 28 Mar 2021 15:11:33 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2DD4861958;
        Sun, 28 Mar 2021 19:11:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1616958693;
        bh=lvoyhqEewdsjU7JtIiNguwjHHN+EZsBNJ0FX3DrkCI4=;
        h=Date:From:To:Subject:From;
        b=01G2BxYMHcZbM/R/8jlvxo2XgJad665AgHJCmMtwt86j7cQ/LxDtHyl0Ochoy2dDL
         3X2mde3Zc4s/cCv2tFBkL4ev5uHkDmF/E12qP1m21RB/EENjm0qY/3CGaNj78auVU+
         zAcXDdB9CQcgYPQGEWzmpLz6LGp6bCAf/7Xa3m+8=
Date:   Sun, 28 Mar 2021 12:11:32 -0700
From:   akpm@linux-foundation.org
To:     axboe@kernel.dk, colin.king@canonical.com, joe@perches.com,
        mm-commits@vger.kernel.org, tom.saeger@oracle.com
Subject:  +
 scripts-spellingtxt-add-entries-for-recent-discoveries.patch added to -mm
 tree
Message-ID: <20210328191132.YcwcEpUxt%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: scripts/spelling.txt: add entries for recent discoveries
has been added to the -mm tree.  Its filename is
     scripts-spellingtxt-add-entries-for-recent-discoveries.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/scripts-spellingtxt-add-entries-for-recent-discoveries.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/scripts-spellingtxt-add-entries-for-recent-discoveries.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Tom Saeger <tom.saeger@oracle.com>
Subject: scripts/spelling.txt: add entries for recent discoveries

Add a few entries for recent spelling fixes found.

Opportunistically de-dupe:
exeeds||exceeds

Link: https://lore.kernel.org/lkml/31acb3239b7ab8989db0c9951e8740050aef0205.1616727528.git.tom.saeger@oracle.com/
Link: https://lore.kernel.org/lkml/fa193b3c9e346ff3fc157b54802c29b25f79c402.1615597995.git.tom.saeger@oracle.com/
Link: https://lkml.kernel.org/r/4a594a9e1536b1d9e5ba57f684c1e41457dd383b.1616861645.git.tom.saeger@oracle.com
Signed-off-by: Tom Saeger <tom.saeger@oracle.com>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Colin Ian King <colin.king@canonical.com>
Cc: Joe Perches <joe@perches.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/spelling.txt |   26 +++++++++++++++++++++++++-
 1 file changed, 25 insertions(+), 1 deletion(-)

--- a/scripts/spelling.txt~scripts-spellingtxt-add-entries-for-recent-discoveries
+++ a/scripts/spelling.txt
@@ -84,6 +84,7 @@ againt||against
 agaist||against
 aggreataon||aggregation
 aggreation||aggregation
+ajust||adjust
 albumns||albums
 alegorical||allegorical
 algined||aligned
@@ -161,10 +162,13 @@ asign||assign
 asser||assert
 assertation||assertion
 assertting||asserting
+assgined||assigned
 assiged||assigned
 assigment||assignment
 assigments||assignments
 assistent||assistant
+assocaited||associated
+assocating||associating
 assocation||association
 associcated||associated
 assotiated||associated
@@ -177,9 +181,11 @@ asynchnous||asynchronous
 asynchromous||asynchronous
 asymetric||asymmetric
 asymmeric||asymmetric
+atleast||at least
 atomatically||automatically
 atomicly||atomically
 atempt||attempt
+atrributes||attributes
 attachement||attachment
 attatch||attach
 attched||attached
@@ -315,6 +321,7 @@ comminucation||communication
 commited||committed
 commiting||committing
 committ||commit
+commnunication||communication
 commoditiy||commodity
 comsume||consume
 comsumer||consumer
@@ -349,6 +356,7 @@ condtion||condition
 conected||connected
 conector||connector
 configration||configuration
+configred||configured
 configuartion||configuration
 configuation||configuration
 configued||configured
@@ -402,6 +410,7 @@ cunter||counter
 curently||currently
 cylic||cyclic
 dafault||default
+deactive||deactivate
 deafult||default
 deamon||daemon
 debouce||debounce
@@ -417,6 +426,7 @@ deffered||deferred
 defferred||deferred
 definate||definite
 definately||definitely
+definiation||definition
 defintion||definition
 defintions||definitions
 defualt||default
@@ -571,8 +581,9 @@ errror||error
 estbalishment||establishment
 etsablishment||establishment
 etsbalishment||establishment
+evalute||evaluate
+evalutes||evaluates
 evalution||evaluation
-exeeds||exceeds
 excecutable||executable
 exceded||exceeded
 exceds||exceeds
@@ -696,6 +707,7 @@ hardare||hardware
 harware||hardware
 havind||having
 heirarchically||hierarchically
+heirarchy||hierarchy
 helpfull||helpful
 heterogenous||heterogeneous
 hexdecimal||hexadecimal
@@ -796,6 +808,7 @@ interanl||internal
 interchangable||interchangeable
 interferring||interfering
 interger||integer
+intergrated||integrated
 intermittant||intermittent
 internel||internal
 interoprability||interoperability
@@ -808,6 +821,7 @@ interrup||interrupt
 interrups||interrupts
 interruptted||interrupted
 interupted||interrupted
+intiailized||initialized
 intial||initial
 intialisation||initialisation
 intialised||initialised
@@ -1091,11 +1105,14 @@ preemptable||preemptible
 prefered||preferred
 prefferably||preferably
 prefitler||prefilter
+preform||perform
 premption||preemption
 prepaired||prepared
 preperation||preparation
 preprare||prepare
 pressre||pressure
+presuambly||presumably
+previosuly||previously
 primative||primitive
 princliple||principle
 priorty||priority
@@ -1265,6 +1282,7 @@ scarch||search
 schdule||schedule
 seach||search
 searchs||searches
+secion||section
 secquence||sequence
 secund||second
 segement||segment
@@ -1312,6 +1330,8 @@ singed||signed
 sleeped||slept
 sliped||slipped
 softwares||software
+soley||solely
+souce||source
 speach||speech
 specfic||specific
 specfield||specified
@@ -1320,7 +1340,9 @@ specifc||specific
 specifed||specified
 specificatin||specification
 specificaton||specification
+specificed||specified
 specifing||specifying
+specifiy||specify
 specifiying||specifying
 speficied||specified
 speicify||specify
@@ -1436,6 +1458,7 @@ timout||timeout
 tmis||this
 toogle||toggle
 torerable||tolerable
+traget||target
 traking||tracking
 tramsmitted||transmitted
 tramsmit||transmit
@@ -1558,6 +1581,7 @@ wiil||will
 wirte||write
 withing||within
 wnat||want
+wont||won't
 workarould||workaround
 writeing||writing
 writting||writing
_

Patches currently in -mm which might be from tom.saeger@oracle.com are

scripts-spellingtxt-add-entries-for-recent-discoveries.patch

