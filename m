Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AB9DBC433DB
	for <mm-commits@archiver.kernel.org>; Thu, 25 Feb 2021 19:14:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 35F0564F6E
	for <mm-commits@archiver.kernel.org>; Thu, 25 Feb 2021 19:14:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233720AbhBYTOT (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 25 Feb 2021 14:14:19 -0500
Received: from mail.kernel.org ([198.145.29.99]:54722 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233922AbhBYTLz (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 25 Feb 2021 14:11:55 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6EEB560201;
        Thu, 25 Feb 2021 19:11:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1614280272;
        bh=E7O4ulvIg70dfFAk3qpLfbTlG/ZgZjii096j8XdI/9o=;
        h=Date:From:To:Subject:From;
        b=XE6VIXHqSXs3A6WQ7BkFQvaM5a7AAkU81ioMimE76y4lCk5dJA8WFql9w1XPWdiXB
         2XbzZ2Fj5MV6mCNkz1sb5QpANTGXgsY3PVHXKOxkrWYFhSDS0Ti6dGi7+yaNG6zvel
         Ty1d3pLRIh5m0K84hrBpHofLTOmz5NJdORrLRSnQ=
Date:   Thu, 25 Feb 2021 11:11:11 -0800
From:   akpm@linux-foundation.org
To:     bcain@codeaurora.org, gregkh@linuxfoundation.org,
        keescook@chromium.org, mm-commits@vger.kernel.org,
        rdunlap@infradead.org
Subject:  [merged]
 hexagon-remove-config_experimental-from-defconfigs.patch removed from -mm
 tree
Message-ID: <20210225191111.TgFIlRa9Z%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: hexagon: remove CONFIG_EXPERIMENTAL from defconfigs
has been removed from the -mm tree.  Its filename was
     hexagon-remove-config_experimental-from-defconfigs.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Randy Dunlap <rdunlap@infradead.org>
Subject: hexagon: remove CONFIG_EXPERIMENTAL from defconfigs

Since CONFIG_EXPERIMENTAL was removed in 2013, go ahead and drop it
from any defconfig files.

Link: https://lkml.kernel.org/r/20210115010011.29483-1-rdunlap@infradead.org
Fixes: 3d374d09f16f ("final removal of CONFIG_EXPERIMENTAL")
Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Cc: Kees Cook <keescook@chromium.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Brian Cain <bcain@codeaurora.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/hexagon/configs/comet_defconfig |    1 -
 1 file changed, 1 deletion(-)

--- a/arch/hexagon/configs/comet_defconfig~hexagon-remove-config_experimental-from-defconfigs
+++ a/arch/hexagon/configs/comet_defconfig
@@ -1,7 +1,6 @@
 CONFIG_SMP=y
 CONFIG_DEFAULT_MMAP_MIN_ADDR=0
 CONFIG_HZ_100=y
-CONFIG_EXPERIMENTAL=y
 CONFIG_CROSS_COMPILE="hexagon-"
 CONFIG_LOCALVERSION="-smp"
 # CONFIG_LOCALVERSION_AUTO is not set
_

Patches currently in -mm which might be from rdunlap@infradead.org are

mm-zswap-clean-up-confusing-comment.patch
alpha-remove-config_experimental-from-defconfigs.patch
include-linux-remove-repeated-words.patch
kernel-delete-repeated-words-in-comments.patch

