Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5C7A9C433E9
	for <mm-commits@archiver.kernel.org>; Fri, 12 Feb 2021 19:17:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1A6D964E99
	for <mm-commits@archiver.kernel.org>; Fri, 12 Feb 2021 19:17:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229451AbhBLTRQ (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 12 Feb 2021 14:17:16 -0500
Received: from mail.kernel.org ([198.145.29.99]:38916 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231430AbhBLTRO (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 12 Feb 2021 14:17:14 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9C70F64EA1;
        Fri, 12 Feb 2021 19:16:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1613157393;
        bh=JZTayZ/Q/VGnq1gLtdinM8XETAQbOgRIOGQN7D0s1+c=;
        h=Date:From:To:Subject:From;
        b=gzYcNWP3Ak7VEoWuj6N/7sV7o8lpnrFB+W86GGTZKDmuknzG0FoJoSrbzFwqis7ff
         GYlBrgYrle5PaLUkONOrH7S7QE5aFfYrnziY4RiCtaGNJ3vRSH5nBA/1awTuh277dR
         YRzI/mRL0q+jPox+SmIGamjN3aT8+kLcFNDaGE2A=
Date:   Fri, 12 Feb 2021 11:16:33 -0800
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, glider@google.com, elver@google.com,
        dvyukov@google.com, andreyknvl@google.com
Subject:  + maintainers-add-andrey-konovalov-to-kasan-reviewers.patch
 added to -mm tree
Message-ID: <20210212191633.j-CgG%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: MAINTAINERS: add Andrey Konovalov to KASAN reviewers
has been added to the -mm tree.  Its filename is
     maintainers-add-andrey-konovalov-to-kasan-reviewers.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/maintainers-add-andrey-konovalov-to-kasan-reviewers.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/maintainers-add-andrey-konovalov-to-kasan-reviewers.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Andrey Konovalov <andreyknvl@google.com>
Subject: MAINTAINERS: add Andrey Konovalov to KASAN reviewers

Add my personal email address to KASAN reviewers list.

Link: https://lkml.kernel.org/r/c1ce89a7aae0e2d6852249c280b1eb59aeac30c0.1613150186.git.andreyknvl@google.com
Signed-off-by: Andrey Konovalov <andreyknvl@google.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Marco Elver <elver@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    1 +
 1 file changed, 1 insertion(+)

--- a/MAINTAINERS~maintainers-add-andrey-konovalov-to-kasan-reviewers
+++ a/MAINTAINERS
@@ -9561,6 +9561,7 @@ F:	drivers/hwmon/k8temp.c
 KASAN
 M:	Andrey Ryabinin <ryabinin.a.a@gmail.com>
 R:	Alexander Potapenko <glider@google.com>
+R:	Andrey Konovalov <andreyknvl@gmail.com>
 R:	Dmitry Vyukov <dvyukov@google.com>
 L:	kasan-dev@googlegroups.com
 S:	Maintained
_

Patches currently in -mm which might be from andreyknvl@google.com are

maintainers-update-kasan-file-list.patch
maintainers-update-andrey-konovalovs-email-address.patch
maintainers-add-andrey-konovalov-to-kasan-reviewers.patch
kasan-prefix-global-functions-with-kasan_.patch
kasan-clarify-hw_tags-impact-on-tbi.patch
kasan-clean-up-comments-in-tests.patch
kasan-add-macros-to-simplify-checking-test-constraints.patch
kasan-add-match-all-tag-tests.patch
kasan-arm64-allow-using-kunit-tests-with-hw_tags-mode.patch
kasan-rename-config_test_kasan_module.patch
kasan-add-compiler-barriers-to-kunit_expect_kasan_fail.patch
kasan-adapt-kmalloc_uaf2-test-to-hw_tags-mode.patch
kasan-fix-memory-corruption-in-kasan_bitops_tags-test.patch
kasan-move-_ret_ip_-to-inline-wrappers.patch
kasan-fix-bug-detection-via-ksize-for-hw_tags-mode.patch
kasan-add-proper-page-allocator-tests.patch
kasan-add-a-test-for-kmem_cache_alloc-free_bulk.patch
kasan-dont-run-tests-when-kasan-is-not-enabled.patch
kfence-kasan-make-kfence-compatible-with-kasan-fix-2.patch
kasan-mm-dont-save-alloc-stacks-twice.patch
kasan-mm-optimize-kmalloc-poisoning.patch
kasan-optimize-large-kmalloc-poisoning.patch
kasan-clean-up-setting-free-info-in-kasan_slab_free.patch
kasan-unify-large-kfree-checks.patch
kasan-rework-krealloc-tests.patch
kasan-mm-fail-krealloc-on-freed-objects.patch
kasan-mm-optimize-krealloc-poisoning.patch
kasan-ensure-poisoning-size-alignment.patch
arm64-kasan-simplify-and-inline-mte-functions.patch
kasan-inline-hw_tags-helper-functions.patch
kasan-clarify-that-only-first-bug-is-reported-in-hw_tags.patch

