Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 839F3C433EF
	for <mm-commits@archiver.kernel.org>; Thu,  9 Dec 2021 00:16:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241445AbhLIAUA (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 8 Dec 2021 19:20:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36250 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238337AbhLIAUA (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 8 Dec 2021 19:20:00 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 767B3C061746
        for <mm-commits@vger.kernel.org>; Wed,  8 Dec 2021 16:16:27 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4859CB8232D
        for <mm-commits@vger.kernel.org>; Thu,  9 Dec 2021 00:16:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BA008C341C7;
        Thu,  9 Dec 2021 00:16:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1639008985;
        bh=pPGaoXV+NlkiLDwm5Ue+Mp/VYLUe42XTpS4TGX02/Rw=;
        h=Date:From:To:Subject:From;
        b=HffPoCWDtQrAYN2bFrk7pBYCfEiOL43Xmk0uBMJs/P402ZgqwuDAZ4bvPTzc3UlaW
         oTeKOO6kGT3O20jJXFJnWK9a4NVVKW9j36ygoeSpA9I3bcnEHzC6T7pIKmtdu2G6gm
         M7lXKN+VUfHVa7xPJdmZAZjJt5nEkBT01rAGC4Qk=
Date:   Wed, 08 Dec 2021 16:16:24 -0800
From:   akpm@linux-foundation.org
To:     alexandre.belloni@bootlin.com, conor.culhane@silvaco.com,
        jianjun.wang@mediatek.com, miquel.raynal@bootlin.com,
        mm-commits@vger.kernel.org, rdunlap@infradead.org,
        ryder.lee@mediatek.com
Subject:  + maintainers-mark-more-list-instances-as-moderated.patch
 added to -mm tree
Message-ID: <20211209001624.neJW8IDYA%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: MAINTAINERS: mark more list instances as moderated
has been added to the -mm tree.  Its filename is
     maintainers-mark-more-list-instances-as-moderated.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/maintainers-mark-more-list-instances-as-moderated.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/maintainers-mark-more-list-instances-as-moderated.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
@@ -14931,7 +14931,7 @@ PCIE DRIVER FOR MEDIATEK
 M:	Ryder Lee <ryder.lee@mediatek.com>
 M:	Jianjun Wang <jianjun.wang@mediatek.com>
 L:	linux-pci@vger.kernel.org
-L:	linux-mediatek@lists.infradead.org
+L:	linux-mediatek@lists.infradead.org (moderated for non-subscribers)
 S:	Supported
 F:	Documentation/devicetree/bindings/pci/mediatek*
 F:	drivers/pci/controller/*mediatek*
@@ -17538,7 +17538,7 @@ F:	drivers/video/fbdev/sm712*
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

maintainers-mark-more-list-instances-as-moderated.patch

