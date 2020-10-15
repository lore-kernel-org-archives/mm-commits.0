Return-Path: <SRS0=txOa=DW=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9664BC433E7
	for <mm-commits@archiver.kernel.org>; Thu, 15 Oct 2020 23:53:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 279CF2074F
	for <mm-commits@archiver.kernel.org>; Thu, 15 Oct 2020 23:53:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1602805996;
	bh=DLdtnI5GfNn0bBEtsJcQAGkLD4Da3ph24fhLD4k6vyo=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=jqxpD+WO2egMkJGE0nEVgkjEEEiEWjA98CBDBmfbXWcNtYzxt2gaJq4/d2M68g/l+
	 jjC3X8OpKvIYW4dfnI2S6UaMp8lgCaGqs2UWRhNFEcmRdDLcA947DwubaCcBVRjakG
	 Rd5dxuERAUiUXkWqthCIxwEKGu4E6VijYssMF+tI=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387894AbgJOXxP (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 15 Oct 2020 19:53:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:50658 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731930AbgJOXxO (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 15 Oct 2020 19:53:14 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6EC0220720;
        Thu, 15 Oct 2020 23:53:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602805993;
        bh=DLdtnI5GfNn0bBEtsJcQAGkLD4Da3ph24fhLD4k6vyo=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=UyW6qzjA/BZeulNTcBInof12H9k+oITvBv5NpgyGGvxuUGgpdBVZKo5Z2TKFuf+5L
         Qqqxgz9/l4izdSPEoMQOmR6fykC3rsQ6KNLDyC66VQ55RN/QK1YJt6wz/IU3D5Qvyb
         0Uj9WlvoRDTIO07UShQsLab286hKdeAU0IFeulX4=
Date:   Thu, 15 Oct 2020 16:53:11 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     corbet@lwn.net, davem@davemloft.net,
        jarkko.sakkinen@linux.intel.com, joe@perches.com,
        keescook@chromium.org, mchehab+huawei@kernel.org,
        mm-commits@vger.kernel.org, robh@kernel.org
Subject:  +
 maintainers-jarkkosakkinen-linuxintelcom-jarkko-kernelorg.patch added to
 -mm tree
Message-ID: <20201015235311.gUlY6Btj1%akpm@linux-foundation.org>
In-Reply-To: <20201013164658.3bfd96cc224d8923e66a9f4e@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: MAINTAINERS: jarkko.sakkinen@linux.intel.com -> jarkko@kernel.org
has been added to the -mm tree.  Its filename is
     maintainers-jarkkosakkinen-linuxintelcom-jarkko-kernelorg.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/maintainers-jarkkosakkinen-linuxintelcom-jarkko-kernelorg.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/maintainers-jarkkosakkinen-linuxintelcom-jarkko-kernelorg.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

maintainers-jarkkosakkinen-linuxintelcom-jarkko-kernelorg.patch

