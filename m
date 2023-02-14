Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5D597C61DA4
	for <mm-commits@archiver.kernel.org>; Tue, 14 Feb 2023 21:40:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229648AbjBNVk5 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 14 Feb 2023 16:40:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37360 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231220AbjBNVkz (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 14 Feb 2023 16:40:55 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 754AC2A6C1
        for <mm-commits@vger.kernel.org>; Tue, 14 Feb 2023 13:40:48 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 136ED618FA
        for <mm-commits@vger.kernel.org>; Tue, 14 Feb 2023 21:40:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6B9A6C433D2;
        Tue, 14 Feb 2023 21:40:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1676410847;
        bh=fFQf5IZCyVMXcofg6Zz0pceCnBzRwo/+9z0VDVIbuhA=;
        h=Date:To:From:Subject:From;
        b=zD8nX7rJViV8CnJpkKije4c0BTXhJLPB0zF/MMXH372hEF7xpAuvAq2K1B2MGRDOR
         e7jqcVVeyYgbOQjzrTRepyyPRrOG8ubPfSpO6AGddvK+nbSlTaE7avQb9qzZMwWc/5
         SwTcpwZgUs+qixuLGfYqSORiOViCbTKw11kGX4JQ=
Date:   Tue, 14 Feb 2023 13:40:46 -0800
To:     mm-commits@vger.kernel.org, billm@melbpc.org.au,
        rdunlap@infradead.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + maintainers-update-fpu-emulator-web-page.patch added to mm-hotfixes-unstable branch
Message-Id: <20230214214047.6B9A6C433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: MAINTAINERS: update FPU EMULATOR web page
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     maintainers-update-fpu-emulator-web-page.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/maintainers-update-fpu-emulator-web-page.patch

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
Subject: MAINTAINERS: update FPU EMULATOR web page
Date: Tue, 14 Feb 2023 09:02:08 -0800

The web page entry for the FPU EMULATOR no longer works.  I notified Bill
of this and he asked me to update it to this new entry.

Link: https://lkml.kernel.org/r/20230214170208.17287-1-rdunlap@infradead.org
Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Acked-by: Bill Metzenthen <billm@melbpc.org.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


--- a/MAINTAINERS~maintainers-update-fpu-emulator-web-page
+++ a/MAINTAINERS
@@ -8196,7 +8196,7 @@ F:	drivers/fpga/microchip-spi.c
 FPU EMULATOR
 M:	Bill Metzenthen <billm@melbpc.org.au>
 S:	Maintained
-W:	http://floatingpoint.sourceforge.net/emulator/index.html
+W:	https://floatingpoint.billm.au/
 F:	arch/x86/math-emu/
 
 FRAMEBUFFER CORE
_

Patches currently in -mm which might be from rdunlap@infradead.org are

maintainers-update-fpu-emulator-web-page.patch

