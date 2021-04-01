Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AAA91C43603
	for <mm-commits@archiver.kernel.org>; Thu,  1 Apr 2021 00:54:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 94851610CC
	for <mm-commits@archiver.kernel.org>; Thu,  1 Apr 2021 00:54:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232763AbhDAAyU (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 31 Mar 2021 20:54:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:33376 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232833AbhDAAyO (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 31 Mar 2021 20:54:14 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7D9AD610C7;
        Thu,  1 Apr 2021 00:54:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1617238454;
        bh=cNATp5fhPmE2sPWlK4O8U2rIpv2SX5O5KW9k//WjoyE=;
        h=Date:From:To:Subject:From;
        b=GkKCW2P9vc7BdPXFNQiuE3kAjV+rEI2d0QT6pozb+ibEisRJBXiqTfMm0w8BQcgjc
         knXst8/faCguX+Ue+Po0I29hP0kdr9YE0i81w0ZbIq0ZmQwLVuZXnPV2yfMAdpFEKo
         afVbzLdInv5XYtd1LHh0DWvbkAkuwsjpOYuqcyo4=
Date:   Wed, 31 Mar 2021 17:54:12 -0700
From:   akpm@linux-foundation.org
To:     aklimov@redhat.com, andriy.shevchenko@linux.intel.com,
        arnd@arndb.de, dalias@libc.org, dennis@kernel.org,
        dsterba@suse.com, geert@linux-m68k.org,
        glaubitz@physik.fu-berlin.de, jianpeng.ma@intel.com,
        joe@perches.com, jpoimboe@redhat.com, linux@rasmusvillemoes.dk,
        mm-commits@vger.kernel.org, richard.weiyang@linux.alibaba.com,
        sbrivio@redhat.com, wsa+renesas@sang-engineering.com,
        ysato@users.osdn.me, yury.norov@gmail.com
Subject:  + maintainers-add-entry-for-the-bitmap-api.patch added to
 -mm tree
Message-ID: <20210401005412.9JpuUPRae%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: MAINTAINERS: add entry for the bitmap API
has been added to the -mm tree.  Its filename is
     maintainers-add-entry-for-the-bitmap-api.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/maintainers-add-entry-for-the-bitmap-api.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/maintainers-add-entry-for-the-bitmap-api.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Yury Norov <yury.norov@gmail.com>
Subject: MAINTAINERS: add entry for the bitmap API

Add myself as maintainer for bitmap API and Andy and Rasmus as reviewers.

Link: https://lkml.kernel.org/r/20210401003153.97325-13-yury.norov@gmail.com
Signed-off-by: Yury Norov <yury.norov@gmail.com>
Acked-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Acked-by: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Cc: Alexey Klimov <aklimov@redhat.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: David Sterba <dsterba@suse.com>
Cc: Dennis Zhou <dennis@kernel.org>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Jianpeng Ma <jianpeng.ma@intel.com>
Cc: Joe Perches <joe@perches.com>
Cc: John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>
Cc: Josh Poimboeuf <jpoimboe@redhat.com>
Cc: Rich Felker <dalias@libc.org>
Cc: Stefano Brivio <sbrivio@redhat.com>
Cc: Wei Yang <richard.weiyang@linux.alibaba.com>
Cc: Wolfram Sang <wsa+renesas@sang-engineering.com>
Cc: Yoshinori Sato <ysato@users.osdn.me>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |   16 ++++++++++++++++
 1 file changed, 16 insertions(+)

--- a/MAINTAINERS~maintainers-add-entry-for-the-bitmap-api
+++ a/MAINTAINERS
@@ -3158,6 +3158,22 @@ F:	Documentation/filesystems/bfs.rst
 F:	fs/bfs/
 F:	include/uapi/linux/bfs_fs.h
 
+BITMAP API
+M:	Yury Norov <yury.norov@gmail.com>
+R:	Andy Shevchenko <andriy.shevchenko@linux.intel.com>
+R:	Rasmus Villemoes <linux@rasmusvillemoes.dk>
+S:	Maintained
+F:	include/asm-generic/bitops/find.h
+F:	include/linux/bitmap.h
+F:	lib/bitmap.c
+F:	lib/find_bit.c
+F:	lib/find_bit_benchmark.c
+F:	lib/test_bitmap.c
+F:	tools/include/asm-generic/bitops/find.h
+F:	tools/include/linux/bitmap.h
+F:	tools/lib/bitmap.c
+F:	tools/lib/find_bit.c
+
 BLINKM RGB LED DRIVER
 M:	Jan-Simon Moeller <jansimon.moeller@gmx.de>
 S:	Maintained
_

Patches currently in -mm which might be from yury.norov@gmail.com are

tools-disable-wno-type-limits.patch
tools-bitmap-sync-function-declarations-with-the-kernel.patch
tools-sync-bitmap_last_word_mask-macro-with-the-kernel.patch
arch-rearrange-headers-inclusion-order-in-asm-bitops-for-m68k-and-sh.patch
lib-extend-the-scope-of-small_const_nbits-macro.patch
tools-sync-small_const_nbits-macro-with-the-kernel.patch
lib-inline-_find_next_bit-wrappers.patch
tools-sync-find_next_bit-implementation.patch
lib-add-fast-path-for-find_next__bit.patch
lib-add-fast-path-for-find_first__bit-and-find_last_bit.patch
tools-sync-lib-find_bit-implementation.patch
maintainers-add-entry-for-the-bitmap-api.patch

