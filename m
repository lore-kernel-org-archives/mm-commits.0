Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B24FBC433E0
	for <mm-commits@archiver.kernel.org>; Sat, 27 Feb 2021 02:32:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8733F64F32
	for <mm-commits@archiver.kernel.org>; Sat, 27 Feb 2021 02:32:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230008AbhB0CcX (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 26 Feb 2021 21:32:23 -0500
Received: from mail.kernel.org ([198.145.29.99]:51478 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229863AbhB0CbO (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 26 Feb 2021 21:31:14 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id F2E7B64F32;
        Sat, 27 Feb 2021 02:30:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1614393058;
        bh=aYrKx/gMsgNVLDxTTA5q67GBMmslMiy6HdHI41Ee1Pk=;
        h=Date:From:To:Subject:From;
        b=SnedMJ+UWsM8toKCtq4tuSXKDSwSQYxpPejyef2Z2YtFzbnWpp/Hd//jSwvVJ7JWu
         M9k+TSYnVmi8+pkyXQ1RWSHpC7me7lDSRq/nKZTAS5JEel5iJ4ZGIvYGqZ/GmVmq6X
         H4hm1+tnA6D90exeEqoEn0Ziy7k76v1+mufxoTTQ=
Date:   Fri, 26 Feb 2021 18:30:57 -0800
From:   akpm@linux-foundation.org
To:     andreyknvl@google.com, aryabinin@virtuozzo.com, bp@alien8.de,
        catalin.marinas@arm.com, cl@linux.com, corbet@lwn.net,
        dave.hansen@linux.intel.com, dvyukov@google.com,
        edumazet@google.com, elver@google.com, glider@google.com,
        gregkh@linuxfoundation.org, hdanton@sina.com, hpa@zytor.com,
        iamjoonsoo.kim@lge.com, jannh@google.com, joern@purestorage.com,
        keescook@chromium.org, luto@kernel.org, mark.rutland@arm.com,
        mingo@redhat.com, mm-commits@vger.kernel.org, paulmck@kernel.org,
        penberg@kernel.org, peterz@infradead.org, rientjes@google.com,
        sjpark@amazon.de, tglx@linutronix.de, vbabka@suse.cz,
        will@kernel.org
Subject:  [merged] maintainers-add-entry-for-kfence.patch removed
 from -mm tree
Message-ID: <20210227023057.uv6j8UD4a%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: MAINTAINERS: add entry for KFENCE
has been removed from the -mm tree.  Its filename was
     maintainers-add-entry-for-kfence.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Marco Elver <elver@google.com>
Subject: MAINTAINERS: add entry for KFENCE

Add entry for KFENCE maintainers.

Link: https://lkml.kernel.org/r/20201103175841.3495947-10-elver@google.com
Signed-off-by: Alexander Potapenko <glider@google.com>
Signed-off-by: Marco Elver <elver@google.com>
Reviewed-by: Dmitry Vyukov <dvyukov@google.com>
Reviewed-by: SeongJae Park <sjpark@amazon.de>
Co-developed-by: Alexander Potapenko <glider@google.com>
Cc: Andrey Konovalov <andreyknvl@google.com>
Cc: Andrey Ryabinin <aryabinin@virtuozzo.com>
Cc: Andy Lutomirski <luto@kernel.org>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Christopher Lameter <cl@linux.com>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Eric Dumazet <edumazet@google.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Hillf Danton <hdanton@sina.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Jann Horn <jannh@google.com>
Cc: Joern Engel <joern@purestorage.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Kees Cook <keescook@chromium.org>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Paul E. McKenney <paulmck@kernel.org>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Will Deacon <will@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |   12 ++++++++++++
 1 file changed, 12 insertions(+)

--- a/MAINTAINERS~maintainers-add-entry-for-kfence
+++ a/MAINTAINERS
@@ -9867,6 +9867,18 @@ F:	include/linux/keyctl.h
 F:	include/uapi/linux/keyctl.h
 F:	security/keys/
 
+KFENCE
+M:	Alexander Potapenko <glider@google.com>
+M:	Marco Elver <elver@google.com>
+R:	Dmitry Vyukov <dvyukov@google.com>
+L:	kasan-dev@googlegroups.com
+S:	Maintained
+F:	Documentation/dev-tools/kfence.rst
+F:	arch/*/include/asm/kfence.h
+F:	include/linux/kfence.h
+F:	lib/Kconfig.kfence
+F:	mm/kfence/
+
 KFIFO
 M:	Stefani Seibold <stefani@seibold.net>
 S:	Maintained
_

Patches currently in -mm which might be from elver@google.com are


