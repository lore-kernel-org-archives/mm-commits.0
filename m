Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2C6B9C433F5
	for <mm-commits@archiver.kernel.org>; Sun, 26 Dec 2021 22:20:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234711AbhLZWUE (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 26 Dec 2021 17:20:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36638 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234705AbhLZWUE (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sun, 26 Dec 2021 17:20:04 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E16C8C06173E
        for <mm-commits@vger.kernel.org>; Sun, 26 Dec 2021 14:20:03 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7E05060F17
        for <mm-commits@vger.kernel.org>; Sun, 26 Dec 2021 22:20:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A5829C36AEB;
        Sun, 26 Dec 2021 22:20:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1640557202;
        bh=PzFmVa2x9UdzrpKkTOladtrEYCFQCR1HeiXamIKJwHs=;
        h=Date:From:To:Subject:From;
        b=RRj04e4b42QbNKJcxTDMCEgm3i44mEEOpIQszezxYg0Eq+8d49JiNP5eDvce1KEZO
         XDgfW4z7myl3r9yRhRvqEzyudPVtyw9mcVb+YIvXUlhT391twScOzHRmVxUo4zTsNo
         lu/Mm/hC6a9vyDEMwonXguTHGa5eW4k7pQPWMqrs=
Date:   Sun, 26 Dec 2021 14:20:02 -0800
From:   akpm@linux-foundation.org
To:     alexandre.belloni@bootlin.com, conor.culhane@silvaco.com,
        jianjun.wang@mediatek.com, miquel.raynal@bootlin.com,
        mm-commits@vger.kernel.org, rdunlap@infradead.org,
        ryder.lee@mediatek.com
Subject:  [merged]
 maintainers-mark-more-list-instances-as-moderated.patch removed from -mm
 tree
Message-ID: <20211226222002.EzJiVyFj3%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: MAINTAINERS: mark more list instances as moderated
has been removed from the -mm tree.  Its filename was
     maintainers-mark-more-list-instances-as-moderated.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Randy Dunlap <rdunlap@infradead.org>
Subject: MAINTAINERS: mark more list instances as moderated

Some lists that are moderated are not marked as moderated consistently, so
mark them all as moderated.

Link: https://lkml.kernel.org/r/20211209001330.18558-1-rdunlap@infradead.org
Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Cc: Miquel Raynal <miquel.raynal@bootlin.com>
Cc: Conor Culhane <conor.culhane@silvaco.com>
Cc: Ryder Lee <ryder.lee@mediatek.com>
Cc: Jianjun Wang <jianjun.wang@mediatek.com>
Cc: Alexandre Belloni <alexandre.belloni@bootlin.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/MAINTAINERS~maintainers-mark-more-list-instances-as-moderated
+++ a/MAINTAINERS
@@ -14845,7 +14845,7 @@ PCIE DRIVER FOR MEDIATEK
 M:	Ryder Lee <ryder.lee@mediatek.com>
 M:	Jianjun Wang <jianjun.wang@mediatek.com>
 L:	linux-pci@vger.kernel.org
-L:	linux-mediatek@lists.infradead.org
+L:	linux-mediatek@lists.infradead.org (moderated for non-subscribers)
 S:	Supported
 F:	Documentation/devicetree/bindings/pci/mediatek*
 F:	drivers/pci/controller/*mediatek*
@@ -17423,7 +17423,7 @@ F:	drivers/video/fbdev/sm712*
 SILVACO I3C DUAL-ROLE MASTER
 M:	Miquel Raynal <miquel.raynal@bootlin.com>
 M:	Conor Culhane <conor.culhane@silvaco.com>
-L:	linux-i3c@lists.infradead.org
+L:	linux-i3c@lists.infradead.org (moderated for non-subscribers)
 S:	Maintained
 F:	Documentation/devicetree/bindings/i3c/silvaco,i3c-master.yaml
 F:	drivers/i3c/master/svc-i3c-master.c
_

Patches currently in -mm which might be from rdunlap@infradead.org are

mm-mempolicy-fix-all-kernel-doc-warnings.patch

