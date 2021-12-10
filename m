Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E818CC433FE
	for <mm-commits@archiver.kernel.org>; Fri, 10 Dec 2021 22:46:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344722AbhLJWtv (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 10 Dec 2021 17:49:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60950 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344718AbhLJWtv (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 10 Dec 2021 17:49:51 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C265C061746
        for <mm-commits@vger.kernel.org>; Fri, 10 Dec 2021 14:46:16 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id CDAC6B82A10
        for <mm-commits@vger.kernel.org>; Fri, 10 Dec 2021 22:46:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 414FFC00446;
        Fri, 10 Dec 2021 22:46:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1639176373;
        bh=xdYlu/9fffMj4IXa9tDNFkMLnAt8zZCaEyJyVMpaKYw=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=G2+3KdRJ4h7UYuyvjS3DToVKH0oawwwmaOugsGCbhrj1mQ7hajF7LCCgA8vyk4uvG
         LHWq1wyzh/1RLsKR/+eUZgV+L+NReG+5/4K/p7M7px5NXQQfBMnEhKdj1YbXThTwPK
         8Opq0ozJi/PkXTNUnJd8dvR2D28od03ezkRz7CjI=
Date:   Fri, 10 Dec 2021 14:46:12 -0800
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, bhe@redhat.com, dyoung@redhat.com,
        linux-mm@kvack.org, mm-commits@vger.kernel.org,
        torvalds@linux-foundation.org
Subject:  [patch 02/21] MAINTAINERS: update kdump maintainers
Message-ID: <20211210224612.OerGy7Pm5%akpm@linux-foundation.org>
In-Reply-To: <20211210144539.663efee2c80d8450e6180230@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Dave Young <dyoung@redhat.com>
Subject: MAINTAINERS: update kdump maintainers

Remove myself from kdump maintainers as I have no enough time to maintain
it now.  But I can review patches on demand though.

Link: https://lkml.kernel.org/r/YZyKilzKFsWJYdgn@dhcp-128-65.nay.redhat.com
Signed-off-by: Dave Young <dyoung@redhat.com>
Acked-by: Baoquan He <bhe@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/MAINTAINERS~maintainers-update-kdump-maintainers
+++ a/MAINTAINERS
@@ -10279,9 +10279,9 @@ F:	lib/Kconfig.kcsan
 F:	scripts/Makefile.kcsan
 
 KDUMP
-M:	Dave Young <dyoung@redhat.com>
 M:	Baoquan He <bhe@redhat.com>
 R:	Vivek Goyal <vgoyal@redhat.com>
+R:	Dave Young <dyoung@redhat.com>
 L:	kexec@lists.infradead.org
 S:	Maintained
 W:	http://lse.sourceforge.net/kdump/
_
