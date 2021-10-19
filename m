Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EA798C4332F
	for <mm-commits@archiver.kernel.org>; Tue, 19 Oct 2021 18:39:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D637061212
	for <mm-commits@archiver.kernel.org>; Tue, 19 Oct 2021 18:39:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232130AbhJSSmE (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 19 Oct 2021 14:42:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:53112 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235001AbhJSSmD (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 19 Oct 2021 14:42:03 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E5B456115B;
        Tue, 19 Oct 2021 18:39:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1634668790;
        bh=3PNtFB0lv/o4sSxI9dUrOSR5IXyRu6GBvrHjG6VBrpU=;
        h=Date:From:To:Subject:From;
        b=zHwj22XLoGwMCjSm2XQqJD+iN/EzR5zsy+ksGIViCx67irlX9+sAxEFDB1k/VRdEX
         NYsiZLnomOQVATXNXyVVlVBdqS10WSaGDm8jdvEsQaR5yWx/n9ZwX0utVk7qrwvyTB
         5BsWx1VSzgBnp/vjK4KqxKTWBDB35R8hHkQSID0g=
Date:   Tue, 19 Oct 2021 11:39:49 -0700
From:   akpm@linux-foundation.org
To:     andrew.shadura@collabora.co.uk, mm-commits@vger.kernel.org
Subject:  [merged] mailmap-add-andrej-shadura.patch removed from
 -mm tree
Message-ID: <20211019183949._LgUbNk1C%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mailmap: add Andrej Shadura
has been removed from the -mm tree.  Its filename was
     mailmap-add-andrej-shadura.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Andrej Shadura <andrew.shadura@collabora.co.uk>
Subject: mailmap: add Andrej Shadura

Add a mapping for my old work email for BelDisplayTech to the personal
email, and make sure the Collabora email has the correct spelling of the
first name.

Link: https://lkml.kernel.org/r/20210917091016.30232-1-andrew.shadura@collabora.co.uk
Signed-off-by: Andrej Shadura <andrew.shadura@collabora.co.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 .mailmap |    2 ++
 1 file changed, 2 insertions(+)

--- a/.mailmap~mailmap-add-andrej-shadura
+++ a/.mailmap
@@ -33,6 +33,8 @@ Al Viro <viro@zenIV.linux.org.uk>
 Andi Kleen <ak@linux.intel.com> <ak@suse.de>
 Andi Shyti <andi@etezian.org> <andi.shyti@samsung.com>
 Andreas Herrmann <aherrman@de.ibm.com>
+Andrej Shadura <andrew.shadura@collabora.co.uk>
+Andrej Shadura <andrew@shadura.me> <andrew@beldisplaytech.com>
 Andrew Morton <akpm@linux-foundation.org>
 Andrew Murray <amurray@thegoodpenguin.co.uk> <amurray@embedded-bits.co.uk>
 Andrew Murray <amurray@thegoodpenguin.co.uk> <andrew.murray@arm.com>
_

Patches currently in -mm which might be from andrew.shadura@collabora.co.uk are


