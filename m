Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 12AC1C46CC7
	for <mm-commits@archiver.kernel.org>; Tue, 14 Nov 2023 23:12:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231784AbjKNXMU (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 14 Nov 2023 18:12:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60964 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231518AbjKNXMT (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 14 Nov 2023 18:12:19 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E3AA3D9
        for <mm-commits@vger.kernel.org>; Tue, 14 Nov 2023 15:12:16 -0800 (PST)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 81E09C433C8;
        Tue, 14 Nov 2023 23:12:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1700003536;
        bh=b1JOmO3QKF4szU71c4tUqpzTvL1EU3ivKCpWceQU2IU=;
        h=Date:To:From:Subject:From;
        b=fbKcsd6GxGuGNLFO+ep/vQ3xk0Dbiw5VAbkLbcjq1rCYCgY/91+JSDj/8oxTYmPS5
         pflbmC2taEoaIe30EZ7q4+xI5iU1h8In7vtMHKsqGImvZln1hNGEZzLN3XaRlGtFxE
         E2d+Pp3JdiBUjZpYn3x8W7HYyi6xxc6JqPZ7jPqY=
Date:   Tue, 14 Nov 2023 15:12:15 -0800
To:     mm-commits@vger.kernel.org, joe@perches.com,
        akpm@linux-foundation.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + maintainers-add-andrew-morton-for-lib.patch added to mm-hotfixes-unstable branch
Message-Id: <20231114231216.81E09C433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: MAINTAINERS: add Andrew Morton for lib/*
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     maintainers-add-andrew-morton-for-lib.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/maintainers-add-andrew-morton-for-lib.patch

This patch will later appear in the mm-hotfixes-unstable branch at
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
From: Andrew Morton <akpm@linux-foundation.org>
Subject: MAINTAINERS: add Andrew Morton for lib/*
Date: Tue Nov 14 03:02:04 PM PST 2023

Add myself as the fallthough maintainer for material under lib/.

Cc: Joe Perches <joe@perches.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/MAINTAINERS~maintainers-add-andrew-morton-for-lib
+++ a/MAINTAINERS
@@ -12209,6 +12209,13 @@ F:	include/linux/nd.h
 F:	include/uapi/linux/ndctl.h
 F:	tools/testing/nvdimm/
 
+LIBRARY CODE
+M:	Andrew Morton <akpm@linux-foundation.org>
+L:	linux-kernel@vger.kernel.org
+S:	Supported
+T:	git git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-nonmm-unstable
+F:	lib/*
+
 LICENSES and SPDX stuff
 M:	Thomas Gleixner <tglx@linutronix.de>
 M:	Greg Kroah-Hartman <gregkh@linuxfoundation.org>
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-fix-for-negative-counter-nr_file_hugepages-fix.patch
maintainers-add-andrew-morton-for-lib.patch
mm-shmem-fix-race-in-shmem_undo_range-w-thp-fix.patch
mm-add-folio_zero_tail-and-use-it-in-ext4-fix.patch
mm-add-folio_fill_tail-and-use-it-in-iomap-fix.patch
kernel-reboot-explicitly-notify-if-halt-occurred-instead-of-power-off-fix.patch

