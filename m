Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5A55AC07E95
	for <mm-commits@archiver.kernel.org>; Thu,  8 Jul 2021 00:31:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 33CA761CB9
	for <mm-commits@archiver.kernel.org>; Thu,  8 Jul 2021 00:31:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230019AbhGHAd4 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 7 Jul 2021 20:33:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:40376 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230000AbhGHAd4 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 7 Jul 2021 20:33:56 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7CA3061C91;
        Thu,  8 Jul 2021 00:31:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1625704274;
        bh=vSUwj4AdA3yl+icLMJLPAOLAOPOa8iEQaSAicP/BSOo=;
        h=Date:From:To:Subject:From;
        b=o6F4ATfl7CYeNGUbOnkfxR6Q0LIi09fJbPyS7VErf6lc6GPspDGdcJCkKnHVj6Bh/
         GGJi3u5kv3kzYtt5Ygc/KNLuIDyz9seeukR5VKudtKm53n5i52h7QvUG8DTk/S8pBo
         AyJg3+7qp2QfIh93vv6LjaGi2P1TlIwj9MNJWMsQ=
Date:   Wed, 07 Jul 2021 17:31:13 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, rppt@linux.ibm.com,
        akpm@linux-foundation.org
Subject:  [folded-merged]
 mm-introduce-memfd_secret-system-call-to-create-secret-memory-areas-fix.patch
 removed from -mm tree
Message-ID: <20210708003113.Am52V%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm-introduce-memfd_secret-system-call-to-create-secret-memory-areas-fix
has been removed from the -mm tree.  Its filename was
     mm-introduce-memfd_secret-system-call-to-create-secret-memory-areas-fix.patch

This patch was dropped because it was folded into mm-introduce-memfd_secret-system-call-to-create-secret-memory-areas.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-introduce-memfd_secret-system-call-to-create-secret-memory-areas-fix

suppress Kconfig whine

Cc: Mike Rapoport <rppt@linux.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/Kconfig |    1 -
 1 file changed, 1 deletion(-)

--- a/mm/Kconfig~mm-introduce-memfd_secret-system-call-to-create-secret-memory-areas-fix
+++ a/mm/Kconfig
@@ -888,6 +888,5 @@ config IO_MAPPING
 
 config SECRETMEM
 	def_bool ARCH_HAS_SET_DIRECT_MAP && !EMBEDDED
-	select STRICT_DEVMEM
 
 endmenu
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-introduce-memfd_secret-system-call-to-create-secret-memory-areas.patch
module-add-printk-formats-to-add-module-build-id-to-stacktraces-fix.patch
module-add-printk-formats-to-add-module-build-id-to-stacktraces-fix-fix.patch
mm.patch
lazy-tlb-allow-lazy-tlb-mm-refcounting-to-be-configurable-fix.patch
kernel-forkc-export-kernel_thread-to-modules.patch

