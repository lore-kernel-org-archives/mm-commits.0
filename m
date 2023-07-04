Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 252DEEB64D9
	for <mm-commits@archiver.kernel.org>; Tue,  4 Jul 2023 16:13:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231233AbjGDQNF (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 4 Jul 2023 12:13:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59926 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231218AbjGDQNF (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 4 Jul 2023 12:13:05 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 60D07DA
        for <mm-commits@vger.kernel.org>; Tue,  4 Jul 2023 09:13:04 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id F3591612C5
        for <mm-commits@vger.kernel.org>; Tue,  4 Jul 2023 16:13:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4CFF9C433C7;
        Tue,  4 Jul 2023 16:13:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1688487183;
        bh=eLNv6OnW5ZFUoO3/LUHEKxhnrGmesuOAQAgLKxRML+w=;
        h=Date:To:From:Subject:From;
        b=FZRcpiWTBSmGuyv2MRip7KXJTR4q5JKEf5GdkWG0PU1Wbth3o1y5PS03PYt+ovD/3
         wa+tmlTfCi9szGkxH8dre3TNtH3eqV0HJV6t9eprvUOFdtEXD3k3E5v42CyNdVSO21
         zyoY1LzxsvGDcKalRxu3YmVLFTCJyIb6vaXyYOBA=
Date:   Tue, 04 Jul 2023 09:13:02 -0700
To:     mm-commits@vger.kernel.org, sfr@canb.auug.org.au,
        rdunlap@infradead.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + maintainers-add-linux-next-info.patch added to mm-hotfixes-unstable branch
Message-Id: <20230704161303.4CFF9C433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: MAINTAINERS: add linux-next info
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     maintainers-add-linux-next-info.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/maintainers-add-linux-next-info.patch

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
From: Randy Dunlap <rdunlap@infradead.org>
Subject: MAINTAINERS: add linux-next info
Date: Mon, 3 Jul 2023 22:44:10 -0700

Add linux-next info to MAINTAINERS for ease of finding this data.

Link: https://lkml.kernel.org/r/20230704054410.12527-1-rdunlap@infradead.org
Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Acked-by: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/MAINTAINERS~maintainers-add-linux-next-info
+++ a/MAINTAINERS
@@ -12105,6 +12105,13 @@ F:	Documentation/litmus-tests/
 F:	Documentation/memory-barriers.txt
 F:	tools/memory-model/
 
+LINUX-NEXT TREE
+M:	Stephen Rothwell <sfr@canb.auug.org.au>
+L:	linux-next@vger.kernel.org
+S:	Supported
+B:	mailto:linux-next@vger.kernel.org and the appropriate development tree
+T:	git git://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git/
+
 LIS3LV02D ACCELEROMETER DRIVER
 M:	Eric Piel <eric.piel@tremplin-utc.net>
 S:	Maintained
_

Patches currently in -mm which might be from rdunlap@infradead.org are

maintainers-add-linux-next-info.patch

