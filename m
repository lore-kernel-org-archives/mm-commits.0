Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CA289C11F64
	for <mm-commits@archiver.kernel.org>; Tue, 29 Jun 2021 02:33:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B3AED61D01
	for <mm-commits@archiver.kernel.org>; Tue, 29 Jun 2021 02:33:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231743AbhF2CgS (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 28 Jun 2021 22:36:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:57006 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231738AbhF2CgR (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 28 Jun 2021 22:36:17 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 637BC61D00;
        Tue, 29 Jun 2021 02:33:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1624934030;
        bh=IclhqLyUus2rPzfxmD0Mrz4Pbp3L7L++dgeSisxIlSE=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=QiFB7L73AkDVZA/FHfAT8PMNozl4NKE/BJvwO8YaFOIaOycIucV9d4i8AT5cMqeOS
         ufg1plAywvaKG4Z0eldvUpqrDo5uiQRABatRNbTLzrBLTFmEic/s6xOqvExZlmZQS+
         CPoKNf8lGq+W6yHM35GUkB2G4TZIAPT97m/YZ13E=
Date:   Mon, 28 Jun 2021 19:33:50 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, colin.king@canonical.com,
        linux-mm@kvack.org, mm-commits@vger.kernel.org,
        torvalds@linux-foundation.org
Subject:  [patch 010/192] scripts/spelling.txt: add more spellings
 to spelling.txt
Message-ID: <20210629023350.gqjkEpCjI%akpm@linux-foundation.org>
In-Reply-To: <20210628193256.008961950a714730751c1423@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

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
