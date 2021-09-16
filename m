Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1F413C433EF
	for <mm-commits@archiver.kernel.org>; Thu, 16 Sep 2021 03:19:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EDF21611C4
	for <mm-commits@archiver.kernel.org>; Thu, 16 Sep 2021 03:19:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234049AbhIPDU5 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 15 Sep 2021 23:20:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:45148 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234037AbhIPDU4 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 15 Sep 2021 23:20:56 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id AABFB611C4;
        Thu, 16 Sep 2021 03:19:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1631762376;
        bh=KZ3s24N0YLHloxaHIrXFmUYSdlVf6YuiTalCxv3laQw=;
        h=Date:From:To:Subject:From;
        b=l7fz1rCPtYO8U/hdSI3rA0Mzt56MbsrXUgTN+LNlSARTLjTQs+hEk5Pmt9fKVkWA8
         EiSn4OQV7buRk0oXPqpAgXAIdWdepO2F4EoK1OUHBkNDzjwi8o35hEUFPqbPvQ1Um5
         H0dSyTd+Zq6qVKPb6mNwP5kRCKS6Nn5s+unNmRO0=
Date:   Wed, 15 Sep 2021 20:19:36 -0700
From:   akpm@linux-foundation.org
To:     colin.king@canonical.com, mm-commits@vger.kernel.org
Subject:  +
 scripts-spellingtxt-add-more-spellings-to-spellingtxt.patch added to -mm
 tree
Message-ID: <20210916031936.Ox6_SYGjx%akpm@linux-foundation.org>
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

scripts-spellingtxt-add-more-spellings-to-spellingtxt.patch

