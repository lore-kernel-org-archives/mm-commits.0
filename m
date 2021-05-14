Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6ADD1C433ED
	for <mm-commits@archiver.kernel.org>; Fri, 14 May 2021 22:10:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 484F561442
	for <mm-commits@archiver.kernel.org>; Fri, 14 May 2021 22:10:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233670AbhENWLs (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 14 May 2021 18:11:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:42602 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229459AbhENWLr (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 14 May 2021 18:11:47 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A135C61182;
        Fri, 14 May 2021 22:10:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1621030235;
        bh=xkJbg1juiNqXctnKsa0vIJ0dnIZe/Ygm7gE1t6PbGUw=;
        h=Date:From:To:Subject:From;
        b=zBP+ArqjPBWI2qRlvIvvT1dIeJSxphGwLzXjP5nwEpbeE+naQOAYuX4rznHwH9Z8R
         yyK8E5peY0HqNw4Ky6dqK/vTr4dpKb/+HvMHRGYBc8NNVNM6Tlrcy8XKiVA8UG/f5f
         Cap7W92j2rafmxPBnnJO2YWP6/Rlh8J+T6dJjWPI=
Date:   Fri, 14 May 2021 15:10:35 -0700
From:   akpm@linux-foundation.org
To:     colin.king@canonical.com, mm-commits@vger.kernel.org
Subject:  +
 scripts-spellingtxt-add-more-spellings-to-spellingtxt.patch added to -mm
 tree
Message-ID: <20210514221035.uyqZe_1JV%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: scripts/spelling.txt: add more spellings to spelling.txt
has been added to the -mm tree.  Its filename is
     scripts-spellingtxt-add-more-spellings-to-spellingtxt.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/scripts-spellingtxt-add-more-spellings-to-spellingtxt.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/scripts-spellingtxt-add-more-spellings-to-spellingtxt.patch

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
found while fixing up spelling mistakes in the kernel in the past few
months.

Link: https://lkml.kernel.org/r/20210514093655.8829-1-colin.king@canonical.com
Signed-off-by: Colin Ian King <colin.king@canonical.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/spelling.txt |   16 ++++++++++++++++
 1 file changed, 16 insertions(+)

--- a/scripts/spelling.txt~scripts-spellingtxt-add-more-spellings-to-spellingtxt
+++ a/scripts/spelling.txt
@@ -22,6 +22,7 @@ absolut||absolute
 absoulte||absolute
 acccess||access
 acceess||access
+accelaration||acceleration
 acceleratoin||acceleration
 accelleration||acceleration
 accesing||accessing
@@ -264,6 +265,7 @@ calucate||calculate
 calulate||calculate
 cancelation||cancellation
 cancle||cancel
+canot||cannot
 capabilites||capabilities
 capabilties||capabilities
 capabilty||capability
@@ -494,7 +496,10 @@ digial||digital
 dimention||dimension
 dimesions||dimensions
 diconnected||disconnected
+disabed||disabled
+disble||disable
 disgest||digest
+disired||desired
 dispalying||displaying
 diplay||display
 directon||direction
@@ -710,6 +715,7 @@ havind||having
 heirarchically||hierarchically
 heirarchy||hierarchy
 helpfull||helpful
+hearbeat||heartbeat
 heterogenous||heterogeneous
 hexdecimal||hexadecimal
 hybernate||hibernate
@@ -989,6 +995,7 @@ notications||notifications
 notifcations||notifications
 notifed||notified
 notity||notify
+nubmer||number
 numebr||number
 numner||number
 obtaion||obtain
@@ -1014,8 +1021,10 @@ ommiting||omitting
 ommitted||omitted
 onself||oneself
 ony||only
+openning||opening
 operatione||operation
 opertaions||operations
+opportunies||opportunities
 optionnal||optional
 optmizations||optimizations
 orientatied||orientated
@@ -1111,6 +1120,7 @@ prefitler||prefilter
 preform||perform
 premption||preemption
 prepaired||prepared
+prepate||prepare
 preperation||preparation
 preprare||prepare
 pressre||pressure
@@ -1123,6 +1133,7 @@ privilaged||privileged
 privilage||privilege
 priviledge||privilege
 priviledges||privileges
+privleges||privileges
 probaly||probably
 procceed||proceed
 proccesors||processors
@@ -1167,6 +1178,7 @@ promixity||proximity
 psudo||pseudo
 psuedo||pseudo
 psychadelic||psychedelic
+purgable||purgeable
 pwoer||power
 queing||queuing
 quering||querying
@@ -1180,6 +1192,7 @@ receieve||receive
 recepient||recipient
 recevied||received
 receving||receiving
+recievd||received
 recieved||received
 recieve||receive
 reciever||receiver
@@ -1228,6 +1241,7 @@ reponse||response
 representaion||representation
 reqeust||request
 reqister||register
+requed||requeued
 requestied||requested
 requiere||require
 requirment||requirement
@@ -1332,6 +1346,7 @@ singal||signal
 singed||signed
 sleeped||slept
 sliped||slipped
+softwade||software
 softwares||software
 soley||solely
 souce||source
@@ -1510,6 +1525,7 @@ unintialized||uninitialized
 unitialized||uninitialized
 unkmown||unknown
 unknonw||unknown
+unknouwn||unknown
 unknow||unknown
 unkown||unknown
 unamed||unnamed
_

Patches currently in -mm which might be from colin.king@canonical.com are

scripts-spellingtxt-add-more-spellings-to-spellingtxt.patch
ocfs2-remove-redundant-assignment-to-pointer-queue.patch

