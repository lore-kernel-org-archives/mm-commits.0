Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C202DC07E96
	for <mm-commits@archiver.kernel.org>; Tue,  6 Jul 2021 19:08:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A941361C75
	for <mm-commits@archiver.kernel.org>; Tue,  6 Jul 2021 19:08:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231802AbhGFTLB (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 6 Jul 2021 15:11:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:45826 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231778AbhGFTK7 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 6 Jul 2021 15:10:59 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 64A6761C6C;
        Tue,  6 Jul 2021 19:08:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1625598500;
        bh=zwcN+ZiDRZjxW2dxagVI2XiA8APqZhapms236l1IBx8=;
        h=Date:From:To:Subject:From;
        b=ak4uwQsyij3cmwNYYpq+AaMnFaj9OJ3i7tBkWKRQ7uvWtzmPmc1WrXvzsxET2Hwu2
         +DZ21W748BQppsYdlxQIq7ZEprhm/olpD/3YSs+iY+Qt1PeoC5HjW7A8VSkwilptP3
         vTWni/6BCj9zXFBvT4Og8K54JeBwhR+jCfMl+66s=
Date:   Tue, 06 Jul 2021 12:08:20 -0700
From:   akpm@linux-foundation.org
To:     colin.king@canonical.com, mm-commits@vger.kernel.org
Subject:  [merged]
 scripts-spellingtxt-add-more-spellings-to-spellingtxt.patch removed from
 -mm tree
Message-ID: <20210706190820.FrH4-Y68y%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: scripts/spelling.txt: add more spellings to spelling.txt
has been removed from the -mm tree.  Its filename was
     scripts-spellingtxt-add-more-spellings-to-spellingtxt.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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


