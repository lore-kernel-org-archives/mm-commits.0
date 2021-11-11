Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 804B9C433EF
	for <mm-commits@archiver.kernel.org>; Thu, 11 Nov 2021 02:39:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 56CE061354
	for <mm-commits@archiver.kernel.org>; Thu, 11 Nov 2021 02:39:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233683AbhKKCmE (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 10 Nov 2021 21:42:04 -0500
Received: from mail.kernel.org ([198.145.29.99]:47718 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233120AbhKKCmE (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 10 Nov 2021 21:42:04 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id E16D361260;
        Thu, 11 Nov 2021 02:39:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1636598356;
        bh=CH0dqmFpskEimANeaavj2PBO5GoZ9MwZ/3b221fkco4=;
        h=Date:From:To:Subject:From;
        b=Khxr/6xC8GTkmL0Wfu/cXI1CdKnYLnpMa3HiUr/8rWp6UbXsEEDOchMQo54uCchJ4
         LgJZ0Ikk5wzAk/7sGIdj8e+YlEP+BLlY82NKOpHzn7rmZ05w0ni9h4pPDDQF7kjBUX
         kVt0wvoBbTMGgNhYv65j/rh6PhqHYzQA3zseAKJw=
Date:   Wed, 10 Nov 2021 18:39:15 -0800
From:   akpm@linux-foundation.org
To:     colin.king@canonical.com, mm-commits@vger.kernel.org
Subject:  [merged]
 scripts-spellingtxt-add-more-spellings-to-spellingtxt.patch removed from
 -mm tree
Message-ID: <20211111023915.y7aHwJJvl%akpm@linux-foundation.org>
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

Some of the more common spelling mistakes and typos that I've found
while fixing up spelling mistakes in the kernel in the past few months.

Link: https://lkml.kernel.org/r/20210907072941.7033-1-colin.king@canonical.com
Signed-off-by: Colin Ian King <colin.king@canonical.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/spelling.txt |   16 ++++++++++++++++
 1 file changed, 16 insertions(+)

--- a/scripts/spelling.txt~scripts-spellingtxt-add-more-spellings-to-spellingtxt
+++ a/scripts/spelling.txt
@@ -178,6 +178,7 @@ assum||assume
 assumtpion||assumption
 asuming||assuming
 asycronous||asynchronous
+asychronous||asynchronous
 asynchnous||asynchronous
 asynchromous||asynchronous
 asymetric||asymmetric
@@ -241,6 +242,7 @@ beter||better
 betweeen||between
 bianries||binaries
 bitmast||bitmask
+bitwiedh||bitwidth
 boardcast||broadcast
 borad||board
 boundry||boundary
@@ -265,7 +267,10 @@ calucate||calculate
 calulate||calculate
 cancelation||cancellation
 cancle||cancel
+cant||can't
+cant'||can't
 canot||cannot
+cann't||can't
 capabilites||capabilities
 capabilties||capabilities
 capabilty||capability
@@ -501,6 +506,7 @@ disble||disable
 disgest||digest
 disired||desired
 dispalying||displaying
+dissable||disable
 diplay||display
 directon||direction
 direcly||directly
@@ -595,6 +601,7 @@ exceded||exceeded
 exceds||exceeds
 exceeed||exceed
 excellant||excellent
+exchnage||exchange
 execeeded||exceeded
 execeeds||exceeds
 exeed||exceed
@@ -938,6 +945,7 @@ migrateable||migratable
 milliseonds||milliseconds
 minium||minimum
 minimam||minimum
+minimun||minimum
 miniumum||minimum
 minumum||minimum
 misalinged||misaligned
@@ -956,6 +964,7 @@ mmnemonic||mnemonic
 mnay||many
 modfiy||modify
 modifer||modifier
+modul||module
 modulues||modules
 momery||memory
 memomry||memory
@@ -1154,6 +1163,7 @@ programable||programmable
 programers||programmers
 programm||program
 programms||programs
+progres||progress
 progresss||progress
 prohibitted||prohibited
 prohibitting||prohibiting
@@ -1328,6 +1338,7 @@ servive||service
 setts||sets
 settting||setting
 shapshot||snapshot
+shoft||shift
 shotdown||shutdown
 shoud||should
 shouldnt||shouldn't
@@ -1439,6 +1450,7 @@ syfs||sysfs
 symetric||symmetric
 synax||syntax
 synchonized||synchronized
+synchronization||synchronization
 synchronuously||synchronously
 syncronize||synchronize
 syncronized||synchronized
@@ -1521,6 +1533,7 @@ unexpexted||unexpected
 unfortunatelly||unfortunately
 unifiy||unify
 uniterrupted||uninterrupted
+uninterruptable||uninterruptible
 unintialized||uninitialized
 unitialized||uninitialized
 unkmown||unknown
@@ -1553,6 +1566,7 @@ unuseful||useless
 unvalid||invalid
 upate||update
 upsupported||unsupported
+useable||usable
 usefule||useful
 usefull||useful
 usege||usage
@@ -1574,6 +1588,7 @@ varient||variant
 vaule||value
 verbse||verbose
 veify||verify
+verfication||verification
 veriosn||version
 verisons||versions
 verison||version
@@ -1586,6 +1601,7 @@ visiters||visitors
 vitual||virtual
 vunerable||vulnerable
 wakeus||wakeups
+was't||wasn't
 wathdog||watchdog
 wating||waiting
 wiat||wait
_

Patches currently in -mm which might be from colin.king@canonical.com are

lib-stackdepot-allow-optional-init-and-stack_table-allocation-by-kvmalloc-fix.patch

