Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B886DC433FE
	for <mm-commits@archiver.kernel.org>; Tue, 15 Nov 2022 00:44:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235927AbiKOAoO (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 14 Nov 2022 19:44:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44266 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236173AbiKOAoM (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 14 Nov 2022 19:44:12 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BDF5C1704B
        for <mm-commits@vger.kernel.org>; Mon, 14 Nov 2022 16:44:11 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5B81A614E2
        for <mm-commits@vger.kernel.org>; Tue, 15 Nov 2022 00:44:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B091AC433D6;
        Tue, 15 Nov 2022 00:44:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1668473050;
        bh=9/PQIa33hiO4VS6yr66KYTycr3dRnERtj/i8erkLOdk=;
        h=Date:To:From:Subject:From;
        b=cCX87RmQxRO39SfjIoDP/qKQUrufudMXLFiALCzL7+02AOcWsLapk9jY+/4tu+R8v
         4BcXyberh3MIDbVu8mh75yy2lyfjI1gSKphyZl2QZOm6jXltfDgu8zQkJepc9VfAwQ
         jELvdCYFszUtwiBgYBrttmvS0SPSKG6ubyg5Byhc=
Date:   Mon, 14 Nov 2022 16:44:09 -0800
To:     mm-commits@vger.kernel.org, alexhung@gmail.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + maintainers-update-alex-hungs-email-address.patch added to mm-hotfixes-unstable branch
Message-Id: <20221115004410.B091AC433D6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: MAINTAINERS: update Alex Hung's email address
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     maintainers-update-alex-hungs-email-address.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/maintainers-update-alex-hungs-email-address.patch

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
From: Alex Hung <alexhung@gmail.com>
Subject: MAINTAINERS: update Alex Hung's email address
Date: Sun, 13 Nov 2022 17:13:02 -0700

Use my personal email address.

Link: https://lkml.kernel.org/r/20221114001302.671897-2-alex.hung@amd.com
Signed-off-by: Alex Hung <alexhung@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/MAINTAINERS~maintainers-update-alex-hungs-email-address
+++ a/MAINTAINERS
@@ -10288,7 +10288,7 @@ T:	git https://github.com/intel/gvt-linu
 F:	drivers/gpu/drm/i915/gvt/
 
 INTEL HID EVENT DRIVER
-M:	Alex Hung <alex.hung@canonical.com>
+M:	Alex Hung <alexhung@gmail.com>
 L:	platform-driver-x86@vger.kernel.org
 S:	Maintained
 F:	drivers/platform/x86/intel/hid.c
_

Patches currently in -mm which might be from alexhung@gmail.com are

mailmap-update-alex-hungs-email-address.patch
maintainers-update-alex-hungs-email-address.patch

