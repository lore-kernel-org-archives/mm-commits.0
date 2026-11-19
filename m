Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795066161;
	b=5buc1fYCHtzUGETNX6wPh70q4QNZ9YJJCKAnCetrJG9j80MzxNZYQmhvLfVZZiDBSmKA
	 S41AgWDAnA6Qc/C+K+diRGE/X6DNIrrjvGYh5bbmfNU56t8Mw/yETz0Ri/8KJNBKHbpPL
	 KKKhJM9qePrP+SSx8McD8c497Iza2HFEl01DtbcJvxU97uA4JyxXGqbTbHimkOrfsrzxG
	 TMTBUswoc1fhIThtiI21oIQ0k6ysPF4jzYuoOde60iVsfX4oxHLj9bxQCcBGkZqFS+jTg
	 sYv3kwZBuP7YBFf5fqliPLlG4OGrP+j829OqbPPrNTyj3LptOCNYWbjTd894iMSp+fA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795066161;
	h=Received:DKIM-Signature:Date:To:From:In-Reply-To:References:Subject:
	 Message-Id;
	bh=aGlnL8n+VwVoEiux8WkGme4M7oqsX3vHgj2cXwoXJg8=;
	b=RGux7M4eTUoGWTg2FCjjJfjyZfHile9xVysaU/wajw/4U+4Kkh/9NtCG8W5nnKI+aDo8
	 TyeYORtGXliJKyHDPLR+Cw0TgYSQqvYD855Tl3tGpdJEzT1AeMFBNLftwUwb009e4VQxI
	 s7vjQxlgFyVqx3czInFNEJx4HrGG8qkM6CIlpxGXYHnDzA66Amc4aAZrh33qjHuPrJQFS
	 pLJdjvc4+NQCTfwz6C0+LNgtNJfvQB3R3UuBkEB8de4JhgFVe8Je08K93Gr5cBEahk4kO
	 4XiHgNzL7LBTDqDmOjMmEOjndjP39o0pB2yS9DEdg6BMjgUy0ZQ8tQeblmH5O2a4cBA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=CX7tUipQ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 44963606A325
	for <mm-commits@vger.kernel.org>; Thu, 19 Nov 2026 05:29:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=CX7tUipQ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0EFE91F000C4;
	Thu, 19 Nov 2026 05:29:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1795066161;
	bh=aGlnL8n+VwVoEiux8WkGme4M7oqsX3vHgj2cXwoXJg8=;
	h=Date:To:From:In-Reply-To:References:Subject;
	b=CX7tUipQVKyzfC/wdueaPwkmqBS3vEfLVsD0GlA6OV7PzvCkqr2EBjgeijW92zn5e
	 5eo8cBtbyR/dJ75aOSvNSTZEAmFvooZWnKufcDxOORVSuyX7a/TrJDqpwFWF8x5JTZ
	 /RlQE+2y74HZwpjHr9Tmya1pqbFsNTqZIhb/ch3A=
Date: Wed, 18 Nov 2026 21:29:20 -0800
To: mm-commits@vger.kernel.org,minchan@kernel.org,senozhatsky@chromium.org,
	akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <80d88d3679dd0b67afe634562e1520aac6686a91.1795061575.git.senozhatsky@chromium.org>
References: <80d88d3679dd0b67afe634562e1520aac6686a91.1795061575.git.senozhatsky@chromium.org>
Subject: + zram-use-spdx-license-identifier.patch added to mm-nonmm-unstable branch
Message-Id: <20261119052921.0EFE91F000C4@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The patch titled
     Subject: zram: use SPDX license identifier
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     zram-use-spdx-license-identifier.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/zram-use-spdx-license-identifier.patch

This patch will later appear in the mm-nonmm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via various
branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there most days

------------------------------------------------------
From: Sergey Senozhatsky <senozhatsky@chromium.org>
Subject: zram: use SPDX license identifier
Date: Thu, 19 Nov 2026 13:13:52 +0900

Replace the license text with the matching SPDX identifier, (GPL-2.0-only
OR BSD-3-Clause).  The copyright notices stay as they are.

Link: https://patch.msgid.link/80d88d3679dd0b67afe634562e1520aac6686a91.1795061575.git.senozhatsky@chromium.org
Signed-off-by: Sergey Senozhatsky <senozhatsky@chromium.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Minchan Kim <minchan@kernel.org>

 drivers/block/zram/zram_drv.c |    8 +-------
 drivers/block/zram/zram_drv.h |    8 +-------
 2 files changed, 2 insertions(+), 14 deletions(-)

--- a/drivers/block/zram/zram_drv.c~zram-use-spdx-license-identifier
+++ a/drivers/block/zram/zram_drv.c
@@ -1,15 +1,9 @@
+// SPDX-License-Identifier: (GPL-2.0-only OR BSD-3-Clause)
 /*
  * Compressed RAM block device
  *
  * Copyright (C) 2008, 2009, 2010  Nitin Gupta
  *               2012, 2013 Minchan Kim
- *
- * This code is released using a dual license strategy: BSD/GPL
- * You can choose the licence that better fits your requirements.
- *
- * Released under the terms of 3-clause BSD License
- * Released under the terms of GNU General Public License Version 2.0
- *
  */
 
 #define pr_fmt(fmt) "zram: " fmt
--- a/drivers/block/zram/zram_drv.h~zram-use-spdx-license-identifier
+++ a/drivers/block/zram/zram_drv.h
@@ -1,15 +1,9 @@
+/* SPDX-License-Identifier: (GPL-2.0-only OR BSD-3-Clause) */
 /*
  * Compressed RAM block device
  *
  * Copyright (C) 2008, 2009, 2010  Nitin Gupta
  *               2012, 2013 Minchan Kim
- *
- * This code is released using a dual license strategy: BSD/GPL
- * You can choose the licence that better fits your requirements.
- *
- * Released under the terms of 3-clause BSD License
- * Released under the terms of GNU General Public License Version 2.0
- *
  */
 
 #ifndef _ZRAM_DRV_H_
_

Patches currently in -mm which might be from senozhatsky@chromium.org are

zram-prefix-backends-printk-s.patch
zram-remove-debugfs-entry-on-init-failure.patch
zram-reset-writeback-state-in-zram_reset_device.patch
zram-move-mark_slot_accessed-under-existing-slot-lock-sections.patch
zram-remove-stale-warn_on-from-zram_read_page.patch
zram-zstd-do-not-allocate-empty-c-d-dictionaries.patch
zram-lz4hc-pre-initialize-dictionary-stream-in-setup_params.patch
zram-lz4-use-lz4_decompress_safe_usingdict.patch
zram-lz4hc-use-lz4_decompress_safe_usingdict.patch
zram-zstd-do-not-use-kvzalloc-for-zstd-allocations.patch
zram-split-zcomp-into-separate-r-w-streams.patch
zram-introduce-shared-decompression-streams.patch
zram-allocate-bounce-buffer-for-spanning-objects.patch
zram-borrow-idle-decompression-streams-in-exclusive-mode.patch
zram-use-a-singleton-compression-context-for-recompression.patch
zram-drop-stale-comment-in-write_incompressible_page.patch
zram-drop-get_slot_handle-and-set_slot_handle.patch
zsmalloc-return-handle-from-obj_allocated.patch
zsmalloc-switch-handle-type-to-struct-zs_handle.patch
zram-check-mem_limit-before-allocating-zsmalloc-object.patch
zram-allocate-zsmalloc-object-under-slot-lock.patch
zswap-do-not-free-the-entry-if-its-pool-is-null.patch
zsmalloc-encode-1-based-obj_idx-so-valid-obj-is-never-0.patch
zsmalloc-embed-struct-zs_handle-into-zram-and-zswap-entries.patch
zsmalloc-fold-zs_obj_write-into-zs_store.patch
zsmalloc-populate-new-zspage-outside-class-lock-in-zs_store.patch
zram-fix-quadratic-writeback-bitmap-search.patch
zsmalloc-fix-spdx-license-identifier.patch
zram-use-spdx-license-identifier.patch

