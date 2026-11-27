Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795749639;
	b=NFAfAd5CdrOAu+h7ngpQEglCVie0QiAILtkcdgkl0wgyihxlEc3vDH6yri1gHt0H2YZr
	 kYj9ockGJbrKCKkmXa0nWmyWV/0ySj/UeHpJKVKBh3lC+wUl7IBRh1wiSXmvzaLe3aDoV
	 GbR1yqrZt2ce9pq5wAbia1BSgsasKggPZMtK4lqOOhCKhJOlfj0x2wq8Ak3GfsUH9wh4E
	 MWpwMhIHahkckYgWJTTAnxgHS68+TO828uwxDqwu0Q7qd82CQO6OjzixU2rPmYCv2yvsa
	 b9IuP9NpwGMYYJEbM4ZCFVEsKRpD+/KWqLdyWCFNTrMqAVXLMV/BKtVRxotBMn8dQSg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795749639;
	h=Received:DKIM-Signature:Date:To:From:In-Reply-To:References:Subject:
	 Message-Id;
	bh=zgaUoC7EiS5GrQK0Ui/T0eIb2WncMzP4WN9LxK2SurQ=;
	b=Qn/i0BMI01YqbWeSnyCOrPXsRRL501NrtF2X7gSgsfQ9ULddgyIj6HOAMTd9+6iktcL6
	 RTc5/hgMNIQtBCUoXtco8q4wVdxSJFrLyY8t9TTbkwZuIHp0vzsOUUenHroWCdYpOcAbO
	 X95/PJv70gCJ9iWx2g7H9Q4HGMzur6DbnJjNNBJVRuh5F+vLD31tL4/gNrGDejwaeLi+J
	 NZBL8rFLn/StVvGgp5zP9W8u1cLmFClPGG0mPI/d6/3iGZCUmY3z4qId8ACjX61+hN3As
	 puHfWWyhQUmbVCandp/fs/bwvyq1ROjNRRUW0X0sn/B4KVSY8eNdj5kHnlv69VBFufQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=XkDZh8+l;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 498E1606A31E
	for <mm-commits@vger.kernel.org>; Fri, 27 Nov 2026 03:20:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=XkDZh8+l
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F25021F00893;
	Fri, 27 Nov 2026 03:20:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1795749639;
	bh=zgaUoC7EiS5GrQK0Ui/T0eIb2WncMzP4WN9LxK2SurQ=;
	h=Date:To:From:In-Reply-To:References:Subject;
	b=XkDZh8+lNNHQUUaP9qkRGX5k+QYy+3LVEaQsAbcVzEloGImDOPEMR74/PP8upBU5r
	 IP3KZSYAxUlVacRxhP3oYMTpEjq3Lqo5Pqz84WEo/mHUFDpsVDYAJ7Ws+FdhmuoLIQ
	 Gwg34tjCXFruLSP6te4z40m/QiSODvYCf0KzTbq4=
Date: Thu, 26 Nov 2026 19:20:38 -0800
To: mm-commits@vger.kernel.org,minchan@kernel.org,senozhatsky@chromium.org,
	akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20261127031658.2049871-1-senozhatsky@chromium.org>
References: <20261127031658.2049871-1-senozhatsky@chromium.org>
Subject: + maintainers-add-mm-and-block-lists-to-zram-entry.patch added to mm-nonmm-unstable branch
Message-Id: <20261127032038.F25021F00893@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The patch titled
     Subject: MAINTAINERS: add mm and block lists to zram entry
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     maintainers-add-mm-and-block-lists-to-zram-entry.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/maintainers-add-mm-and-block-lists-to-zram-entry.patch

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
Subject: MAINTAINERS: add mm and block lists to zram entry
Date: Fri, 27 Nov 2026 12:16:38 +0900

Route zram patches via linux-mm and linux-block lists, rather than through
the generic linux-kernel.

While at it, fix a DRVIER typo.

Link: https://patch.msgid.link/20261127031658.2049871-1-senozhatsky@chromium.org
Signed-off-by: Sergey Senozhatsky <senozhatsky@chromium.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Minchan Kim <minchan@kernel.org>

 MAINTAINERS |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/MAINTAINERS~maintainers-add-mm-and-block-lists-to-zram-entry
+++ a/MAINTAINERS
@@ -30933,10 +30933,11 @@ Q:	https://patchwork.linuxtv.org/project
 F:	Documentation/driver-api/media/drivers/zoran.rst
 F:	drivers/media/pci/zoran/
 
-ZRAM COMPRESSED RAM BLOCK DEVICE DRVIER
+ZRAM COMPRESSED RAM BLOCK DEVICE DRIVER
 M:	Minchan Kim <minchan@kernel.org>
 M:	Sergey Senozhatsky <senozhatsky@chromium.org>
-L:	linux-kernel@vger.kernel.org
+L:	linux-mm@kvack.org
+L:	linux-block@vger.kernel.org
 S:	Maintained
 F:	Documentation/ABI/testing/sysfs-block-zram
 F:	Documentation/ABI/testing/sysfs-class-zram
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
zsmalloc-free-a-zspages-pages-in-one-batch.patch
zram-keep-the-hot-statistics-per-cpu.patch
zram-do-not-modify-cont-sysfs-store-buffers.patch
zsmalloc-fix-spdx-license-identifier.patch
zram-use-spdx-license-identifier.patch
maintainers-add-mm-and-block-lists-to-zram-entry.patch

