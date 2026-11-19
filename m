Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795066158;
	b=aaSjySGL0GJDBQz8I00aFE/PJtSGhIcmfTujnDaFusDZQ68tK1kcitU58cIhr1Rm7KJS
	 P2LPLsQ8LSnR9R9yrM6nSy7OgJVq0pcwg3m89F9aIscA3z54D/75xUI1naQ0xdAukWek8
	 LytPWSgp2t4jIaStTOr+61Ha8YyDjssy5fMztpJQqc9M3uqQJFBjSsczFEikCM/xM5NT7
	 gX1Qqp8Kinvq3HScwkQgQ88kjvrTrnWOYOheUgjfZRui8d0KBPGIKJ5mJsImGnNAe025S
	 sGvtV5r7r9GjdHhiCGjvOu6swb9GszhXJDWrfZI00Q/D4ZUHMyzKkBovQLzgI9lf6+A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795066158;
	h=Received:DKIM-Signature:Date:To:From:In-Reply-To:References:Subject:
	 Message-Id;
	bh=87sREUPHkk4rL24N95k3RYh0XUs6qPXx52jmoqCU4a0=;
	b=4P4ALg1dNtz4AKPh1RCVST4Y9Bapp0Y3Us4lg2U0VB16d9+wHj7eaqGD4eGyGN8X8Rzp
	 X74UUlb7mHVXWZGkRpyEH1ogiBCmzlO2GHJxj2bUtWCRi6iVRLhi++21Eil+9U8CUfpP9
	 QzJpweu1tomsPm98+qZMknUhArKO0GLfgERWuwJlHJxPmePXpFiOYDPU4pRtsjfxHj2ww
	 68lZ3TZLLjAy6jlL7+fH/yZFCp0UgmKja626I0Ab1gHpSs0nnw7jZvXQNbj19v8FX55Ti
	 jJKV4QQHf1TsuhhAwM2GBPEuLyFkzmjniYJBdcUPEhOMVIwnk4xVU5m6I9bF+U1Xqug==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=RgQhlWZA;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 46918606A320
	for <mm-commits@vger.kernel.org>; Thu, 19 Nov 2026 05:29:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=RgQhlWZA
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 007BD1F000C4;
	Thu, 19 Nov 2026 05:29:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1795066158;
	bh=87sREUPHkk4rL24N95k3RYh0XUs6qPXx52jmoqCU4a0=;
	h=Date:To:From:In-Reply-To:References:Subject;
	b=RgQhlWZAPrrHM22U99OapmzycRfRCFyOkvYKM1NUtxpIG+yGtKKxB/u5kB/ZhWD8O
	 51aBkopmuYbDA/cbkP5FYC572YlTjotjpeBdpfHUCYLu29S4eZyFBRe3SVpEZKCxrf
	 x74TZzLBjaW9NFKZ/5uvz2xyfQ2Pb/mkIsKyk4bc=
Date: Wed, 18 Nov 2026 21:29:17 -0800
To: mm-commits@vger.kernel.org,minchan@kernel.org,senozhatsky@chromium.org,
	akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <39f6056e0c8834fc3eca2001fcb44f3b6048f74d.1795061575.git.senozhatsky@chromium.org>
References: <39f6056e0c8834fc3eca2001fcb44f3b6048f74d.1795061575.git.senozhatsky@chromium.org>
Subject: + zsmalloc-fix-spdx-license-identifier.patch added to mm-nonmm-unstable branch
Message-Id: <20261119052918.007BD1F000C4@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The patch titled
     Subject: zsmalloc: fix SPDX license identifier
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     zsmalloc-fix-spdx-license-identifier.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/zsmalloc-fix-spdx-license-identifier.patch

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
Subject: zsmalloc: fix SPDX license identifier
Date: Thu, 19 Nov 2026 13:13:51 +0900

zsmalloc is released under MODULE_LICENSE("Dual BSD/GPL") so the existing
SPDX license identifier is incorrect.

Use the matching identifier, (GPL-2.0-only OR BSD-3-Clause), and drop the
license text that it replaces.  The copyright notices stay as they are.

Link: https://patch.msgid.link/39f6056e0c8834fc3eca2001fcb44f3b6048f74d.1795061575.git.senozhatsky@chromium.org
Signed-off-by: Sergey Senozhatsky <senozhatsky@chromium.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Minchan Kim <minchan@kernel.org>

 include/linux/zsmalloc.h |    7 +------
 mm/zsmalloc.c            |    8 +-------
 2 files changed, 2 insertions(+), 13 deletions(-)

--- a/include/linux/zsmalloc.h~zsmalloc-fix-spdx-license-identifier
+++ a/include/linux/zsmalloc.h
@@ -1,14 +1,9 @@
+/* SPDX-License-Identifier: (GPL-2.0-only OR BSD-3-Clause) */
 /*
  * zsmalloc memory allocator
  *
  * Copyright (C) 2011  Nitin Gupta
  * Copyright (C) 2012, 2013 Minchan Kim
- *
- * This code is released using a dual license strategy: BSD/GPL
- * You can choose the license that better fits your requirements.
- *
- * Released under the terms of 3-clause BSD License
- * Released under the terms of GNU General Public License Version 2.0
  */
 
 #ifndef _ZS_MALLOC_H_
--- a/mm/zsmalloc.c~zsmalloc-fix-spdx-license-identifier
+++ a/mm/zsmalloc.c
@@ -1,16 +1,10 @@
-// SPDX-License-Identifier: GPL-2.0-or-later
+// SPDX-License-Identifier: (GPL-2.0-only OR BSD-3-Clause)
 
 /*
  * zsmalloc memory allocator
  *
  * Copyright (C) 2011  Nitin Gupta
  * Copyright (C) 2012, 2013 Minchan Kim
- *
- * This code is released using a dual license strategy: BSD/GPL
- * You can choose the license that better fits your requirements.
- *
- * Released under the terms of 3-clause BSD License
- * Released under the terms of GNU General Public License Version 2.0
  */
 
 #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
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

