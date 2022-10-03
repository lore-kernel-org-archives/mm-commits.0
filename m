Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8E4C6C433FE
	for <mm-commits@archiver.kernel.org>; Mon,  3 Oct 2022 21:14:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229954AbiJCVOs (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 3 Oct 2022 17:14:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55946 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230150AbiJCVNg (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 3 Oct 2022 17:13:36 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AC19F4D4FD
        for <mm-commits@vger.kernel.org>; Mon,  3 Oct 2022 14:08:26 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 66FE6B81122
        for <mm-commits@vger.kernel.org>; Mon,  3 Oct 2022 21:08:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 11089C433C1;
        Mon,  3 Oct 2022 21:08:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1664831304;
        bh=W7d0KeeEydwjs48OChY3DmTJy2XF19+tC0RCSfJOp3w=;
        h=Date:To:From:Subject:From;
        b=bsUWaB+A1DZAx630zeoXthW5LJQNkWMBTwQx3mb0+9K8C3aY5+Ik0hYPcqu0MG9lo
         LcBT3BBzkGO811k3pE4TPakAlnYhv7I8XlSEXy4g5rV62rCi7wwmZEMxxGlUM/t5nO
         2L/l2utJTcq2vlC3BgmEGfLtZ5bKzPaeXil/beZY=
Date:   Mon, 03 Oct 2022 14:08:23 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        viro@zeniv.linux.org.uk, vegard.nossum@oracle.com, vbabka@suse.cz,
        tglx@linutronix.de, sfr@canb.auug.org.au, rostedt@goodmis.org,
        rientjes@google.com, pmladek@suse.com, peterz@infradead.org,
        penberg@kernel.org, mst@redhat.com, mingo@redhat.com,
        mark.rutland@arm.com, luto@kernel.org, keescook@chromium.org,
        iii@linux.ibm.com, iamjoonsoo.kim@lge.com,
        herbert@gondor.apana.org.au, hch@lst.de,
        gregkh@linuxfoundation.org, gor@linux.ibm.com, elver@google.com,
        edumazet@google.com, ebiggers@kernel.org, ebiggers@google.com,
        dvyukov@google.com, cl@linux.com, bp@alien8.de, axboe@kernel.dk,
        ast@kernel.org, arnd@arndb.de, andreyknvl@google.com,
        andreyknvl@gmail.com, glider@google.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] maintainers-add-entry-for-kmsan.patch removed from -mm tree
Message-Id: <20221003210824.11089C433C1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: MAINTAINERS: add entry for KMSAN
has been removed from the -mm tree.  Its filename was
     maintainers-add-entry-for-kmsan.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Alexander Potapenko <glider@google.com>
Subject: MAINTAINERS: add entry for KMSAN
Date: Thu, 15 Sep 2022 17:03:47 +0200

Add entry for KMSAN maintainers/reviewers.

Link: https://lkml.kernel.org/r/20220915150417.722975-14-glider@google.com
Signed-off-by: Alexander Potapenko <glider@google.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Alexei Starovoitov <ast@kernel.org>
Cc: Andrey Konovalov <andreyknvl@gmail.com>
Cc: Andrey Konovalov <andreyknvl@google.com>
Cc: Andy Lutomirski <luto@kernel.org>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Christoph Lameter <cl@linux.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Eric Biggers <ebiggers@google.com>
Cc: Eric Biggers <ebiggers@kernel.org>
Cc: Eric Dumazet <edumazet@google.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Ilya Leoshkevich <iii@linux.ibm.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Kees Cook <keescook@chromium.org>
Cc: Marco Elver <elver@google.com>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Michael S. Tsirkin <mst@redhat.com>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Petr Mladek <pmladek@suse.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Vasily Gorbik <gor@linux.ibm.com>
Cc: Vegard Nossum <vegard.nossum@oracle.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |   13 +++++++++++++
 1 file changed, 13 insertions(+)

--- a/MAINTAINERS~maintainers-add-entry-for-kmsan
+++ a/MAINTAINERS
@@ -11371,6 +11371,19 @@ F:	kernel/kmod.c
 F:	lib/test_kmod.c
 F:	tools/testing/selftests/kmod/
 
+KMSAN
+M:	Alexander Potapenko <glider@google.com>
+R:	Marco Elver <elver@google.com>
+R:	Dmitry Vyukov <dvyukov@google.com>
+L:	kasan-dev@googlegroups.com
+S:	Maintained
+F:	Documentation/dev-tools/kmsan.rst
+F:	arch/*/include/asm/kmsan.h
+F:	include/linux/kmsan*.h
+F:	lib/Kconfig.kmsan
+F:	mm/kmsan/
+F:	scripts/Makefile.kmsan
+
 KPROBES
 M:	Naveen N. Rao <naveen.n.rao@linux.ibm.com>
 M:	Anil S Keshavamurthy <anil.s.keshavamurthy@intel.com>
_

Patches currently in -mm which might be from glider@google.com are


