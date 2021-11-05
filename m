Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0F367C433F5
	for <mm-commits@archiver.kernel.org>; Fri,  5 Nov 2021 20:34:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id ECAF5611EE
	for <mm-commits@archiver.kernel.org>; Fri,  5 Nov 2021 20:34:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230369AbhKEUhc (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 5 Nov 2021 16:37:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:60358 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231138AbhKEUh2 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 5 Nov 2021 16:37:28 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4EF57611CE;
        Fri,  5 Nov 2021 20:34:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1636144477;
        bh=y0hh9s32gA0j1+uUPy4IiJlbyl3LxBF0a4Mwnq0as0M=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=yfHQKq8tiTOqNty6NmO+RucY7JcgAQVoMtdgZqszPcOo/wFCX+vr9Yt2m0Q4yenXW
         igH0GlSOm1c4ZzMCmgPgGSeV7PCO4OKIGQdJTOC6ZBcbLUxsADiFHz3GHeb48CYxYJ
         iML5I7HzxD7YlMCLGD63LUBdEQf3kEWknc5+FJU4=
Date:   Fri, 05 Nov 2021 13:34:36 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, colin.king@canonical.com,
        linux-mm@kvack.org, mm-commits@vger.kernel.org,
        torvalds@linux-foundation.org
Subject:  [patch 001/262] scripts/spelling.txt: add more spellings
 to spelling.txt
Message-ID: <20211105203436.hC7p6A2-9%akpm@linux-foundation.org>
In-Reply-To: <20211105133408.cccbb98b71a77d5e8430aba1@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

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
