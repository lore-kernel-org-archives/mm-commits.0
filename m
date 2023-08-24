Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 45209C3DA6F
	for <mm-commits@archiver.kernel.org>; Thu, 24 Aug 2023 17:30:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240946AbjHXRaR (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 24 Aug 2023 13:30:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47808 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242868AbjHXR37 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 24 Aug 2023 13:29:59 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ACFD51BC8
        for <mm-commits@vger.kernel.org>; Thu, 24 Aug 2023 10:29:55 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 42FA766FD8
        for <mm-commits@vger.kernel.org>; Thu, 24 Aug 2023 17:29:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 99089C433C8;
        Thu, 24 Aug 2023 17:29:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1692898194;
        bh=2KCgzw4i4i66kEF3EEmnsX3z+haCfC5o4tReIHjAYLg=;
        h=Date:To:From:Subject:From;
        b=XQNObWr9s1Gr/R9DOmb0Z0AmsPNayEDbkwut44a8vWZQYCy00zx+iH7llpHXTra8l
         /mhFKKZ4vyDD97tJKpAL9I2QkUegJUiFwXB+U38t8L0yVrLw/9jPLovaTMI0El6wOo
         EfzP+Ft5UcDAUDkS42NfBAJK31ipHmv4XVFQOCu8=
Date:   Thu, 24 Aug 2023 10:29:53 -0700
To:     mm-commits@vger.kernel.org, david@redhat.com, baruch@tkos.co.il,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + maintainers-add-rmaph-to-mm-entry.patch added to mm-unstable branch
Message-Id: <20230824172954.99089C433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: MAINTAINERS: add rmap.h to mm entry
has been added to the -mm mm-unstable branch.  Its filename is
     maintainers-add-rmaph-to-mm-entry.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/maintainers-add-rmaph-to-mm-entry.patch

This patch will later appear in the mm-unstable branch at
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
From: Baruch Siach <baruch@tkos.co.il>
Subject: MAINTAINERS: add rmap.h to mm entry
Date: Thu, 24 Aug 2023 14:38:09 +0300

Make it easier to figure out where to send patches for this file.

Link: https://lkml.kernel.org/r/efbc7689d35a48ff402644d696aa9a8d8bb6333a.1692877089.git.baruch@tkos.co.il
Signed-off-by: Baruch Siach <baruch@tkos.co.il>
Reviewed-by: David Hildenbrand <david@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    1 +
 1 file changed, 1 insertion(+)

--- a/MAINTAINERS~maintainers-add-rmaph-to-mm-entry
+++ a/MAINTAINERS
@@ -13622,6 +13622,7 @@ F:	include/linux/memory_hotplug.h
 F:	include/linux/mm.h
 F:	include/linux/mmzone.h
 F:	include/linux/pagewalk.h
+F:	include/linux/rmap.h
 F:	include/trace/events/ksm.h
 F:	mm/
 F:	tools/mm/
_

Patches currently in -mm which might be from baruch@tkos.co.il are

rmap-remove-anon_vma_link-nommu-stub.patch
maintainers-add-rmaph-to-mm-entry.patch

