Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 27EAEC4167B
	for <mm-commits@archiver.kernel.org>; Wed,  6 Dec 2023 17:58:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1378951AbjLFR6l (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 6 Dec 2023 12:58:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49214 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1379053AbjLFR6k (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 6 Dec 2023 12:58:40 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 70CB1D5B
        for <mm-commits@vger.kernel.org>; Wed,  6 Dec 2023 09:58:46 -0800 (PST)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EF303C433C7;
        Wed,  6 Dec 2023 17:58:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1701885526;
        bh=G/JrjsJK7uTaaDsl+LSNP7fIX49e0GORIkBYylbvtyg=;
        h=Date:To:From:Subject:From;
        b=zAWXJuIx32cYP6sMsIBJXpGNPnWl6P/8JKS+yRINfGrd+7LvjVBCW6sotjlW8T5+2
         uYhC8lUGhimcD3H9vortwzUMIRX649dgvL7LctIBwrGBRXMlNC8QmcJAR4h5ZOvS+2
         hb0yxhX4vvyA+EY8U+CN7L0sZHRgcN3Jubdgs3ic=
Date:   Wed, 06 Dec 2023 09:58:45 -0800
To:     mm-commits@vger.kernel.org, keescook@chromium.org,
        ebiederm@xmission.com, adobriyan@gmail.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + elf-maintainers-specifically-mention-elf.patch added to mm-hotfixes-unstable branch
Message-Id: <20231206175845.EF303C433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: ELF, MAINTAINERS: specifically mention ELF
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     elf-maintainers-specifically-mention-elf.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/elf-maintainers-specifically-mention-elf.patch

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
From: Alexey Dobriyan <adobriyan@gmail.com>
Subject: ELF, MAINTAINERS: specifically mention ELF
Date: Wed, 6 Dec 2023 12:21:42 +0300

People complain when I miss people in Cc.

Link: https://lkml.kernel.org/r/2cb0891e-d7c0-4939-bb5f-282812de6078@p183
Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Eric Biederman <ebiederm@xmission.com>
Cc: Kees Cook <keescook@chromium.org>

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/MAINTAINERS~elf-maintainers-specifically-mention-elf
+++ a/MAINTAINERS
@@ -7880,7 +7880,7 @@ F:	include/uapi/linux/mdio.h
 F:	include/uapi/linux/mii.h
 F:	net/core/of_net.c
 
-EXEC & BINFMT API
+EXEC & BINFMT API, ELF
 R:	Eric Biederman <ebiederm@xmission.com>
 R:	Kees Cook <keescook@chromium.org>
 L:	linux-mm@kvack.org
_

Patches currently in -mm which might be from adobriyan@gmail.com are

elf-maintainers-specifically-mention-elf.patch

