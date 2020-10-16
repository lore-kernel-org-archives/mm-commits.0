Return-Path: <SRS0=zz/k=DX=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNWANTED_LANGUAGE_BODY,URIBL_BLOCKED
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A8722C43457
	for <mm-commits@archiver.kernel.org>; Fri, 16 Oct 2020 20:52:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 57F1D2065D
	for <mm-commits@archiver.kernel.org>; Fri, 16 Oct 2020 20:52:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1602881570;
	bh=H9818hNMm/bb2o5hQw92lJ8KQe4MOntu8/WDM6YJPZo=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=BdHCv3ABkmN3jhjTQMY1W0/kXC0mmtNsyOW0nuyzQ0jrhf0XN9fpDIdD+Rq7LNx/X
	 H6NtA7eTl5MgjLU9Xu0teiV7/k1/rPK1XlSGoPpXi/xhtHZd7CsmhLv5WPB/B28G5h
	 nWRbjd7IoXHns92pyBzcWuO5AsnpYAWEG8THCz0s=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2409051AbgJPUwt (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 16 Oct 2020 16:52:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:41190 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2408456AbgJPUwt (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 16 Oct 2020 16:52:49 -0400
Received: from localhost.localdomain (c-71-198-47-131.hsd1.ca.comcast.net [71.198.47.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9DBA62064B;
        Fri, 16 Oct 2020 20:52:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602881569;
        bh=H9818hNMm/bb2o5hQw92lJ8KQe4MOntu8/WDM6YJPZo=;
        h=Date:From:To:Subject:From;
        b=sRLH53yLFtSFRDxNAsi83i/Gfbivl4YA0glDZl+E2b5y+vh2y1bgiB+Mk1O9whe+V
         PkeTXgt1WlYTo8iPUVPuygv1M3k1zYabDTIW4fOPZeotSvfJg5qDW2FTDrCH7STxa0
         J4RVoFqlvSx7r1dqVe0MzYnPwjx8meLO6I2r0hSQ=
Date:   Fri, 16 Oct 2020 13:52:48 -0700
From:   akpm@linux-foundation.org
To:     corbet@lwn.net, davem@davemloft.net,
        jarkko.sakkinen@linux.intel.com, joe@perches.com,
        keescook@chromium.org, mchehab+huawei@kernel.org,
        mm-commits@vger.kernel.org, robh@kernel.org
Subject:  [merged]
 maintainers-jarkkosakkinen-linuxintelcom-jarkko-kernelorg.patch removed
 from -mm tree
Message-ID: <20201016205248.gkuRxrzAY%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: MAINTAINERS: jarkko.sakkinen@linux.intel.com -> jarkko@kernel.org
has been removed from the -mm tree.  Its filename was
     maintainers-jarkkosakkinen-linuxintelcom-jarkko-kernelorg.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Subject: MAINTAINERS: jarkko.sakkinen@linux.intel.com -> jarkko@kernel.org

Use @kernel.org address as the main communications end point.  Update the
corresponding M-entries and .mailmap (for git shortlog translation).

Link: https://lkml.kernel.org/r/20201015142710.8371-1-jarkko.sakkinen@linux.intel.com
Signed-off-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Cc: Joe Perches <joe@perches.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Kees Cook <keescook@chromium.org>
Cc: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Rob Herring <robh@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 .mailmap    |    1 +
 MAINTAINERS |    6 +++---
 2 files changed, 4 insertions(+), 3 deletions(-)

--- a/.mailmap~maintainers-jarkkosakkinen-linuxintelcom-jarkko-kernelorg
+++ a/.mailmap
@@ -133,6 +133,7 @@ James Ketrenos <jketreno@io.(none)>
 Jan Glauber <jan.glauber@gmail.com> <jang@de.ibm.com>
 Jan Glauber <jan.glauber@gmail.com> <jang@linux.vnet.ibm.com>
 Jan Glauber <jan.glauber@gmail.com> <jglauber@cavium.com>
+Jarkko Sakkinen <jarkko@kernel.org> <jarkko.sakkinen@linux.intel.com>
 Jason Gunthorpe <jgg@ziepe.ca> <jgg@mellanox.com>
 Jason Gunthorpe <jgg@ziepe.ca> <jgg@nvidia.com>
 Jason Gunthorpe <jgg@ziepe.ca> <jgunthorpe@obsidianresearch.com>
--- a/MAINTAINERS~maintainers-jarkkosakkinen-linuxintelcom-jarkko-kernelorg
+++ a/MAINTAINERS
@@ -9701,7 +9701,7 @@ F:	security/keys/encrypted-keys/
 
 KEYS-TRUSTED
 M:	James Bottomley <jejb@linux.ibm.com>
-M:	Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
+M:	Jarkko Sakkinen <jarkko@kernel.org>
 M:	Mimi Zohar <zohar@linux.ibm.com>
 L:	linux-integrity@vger.kernel.org
 L:	keyrings@vger.kernel.org
@@ -9713,7 +9713,7 @@ F:	security/keys/trusted-keys/
 
 KEYS/KEYRINGS
 M:	David Howells <dhowells@redhat.com>
-M:	Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
+M:	Jarkko Sakkinen <jarkko@kernel.org>
 L:	keyrings@vger.kernel.org
 S:	Maintained
 F:	Documentation/security/keys/core.rst
@@ -17684,7 +17684,7 @@ F:	drivers/platform/x86/toshiba-wmi.c
 
 TPM DEVICE DRIVER
 M:	Peter Huewe <peterhuewe@gmx.de>
-M:	Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
+M:	Jarkko Sakkinen <jarkko@kernel.org>
 R:	Jason Gunthorpe <jgg@ziepe.ca>
 L:	linux-integrity@vger.kernel.org
 S:	Maintained
_

Patches currently in -mm which might be from jarkko.sakkinen@linux.intel.com are


