Return-Path: <SRS0=zz/k=DX=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3B863C433DF
	for <mm-commits@archiver.kernel.org>; Fri, 16 Oct 2020 03:10:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DE32A208C7
	for <mm-commits@archiver.kernel.org>; Fri, 16 Oct 2020 03:10:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1602817843;
	bh=JCs2BERosMVoZjElyLQ5eEqvxPLHsruZUIS3G2v6KsU=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=mNf4uoQUKb9svy+8qZk5Imfg1mstKSMwciyYjZL01duCCLAFc6xOk9HMT3ozWiVtW
	 Aa+5s3CtlQpiZAdrZ2QU04E2TLXJYyllj3cpa9NA/susVsRZ1BFyGGIXBmyGoqzAOO
	 eDA4K+UuDSqIslScjiplo/bg9xdQGSKiVodeFi/Q=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732461AbgJPDKn (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 15 Oct 2020 23:10:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:47626 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731974AbgJPDKn (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 15 Oct 2020 23:10:43 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5FFB920878;
        Fri, 16 Oct 2020 03:10:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602817842;
        bh=JCs2BERosMVoZjElyLQ5eEqvxPLHsruZUIS3G2v6KsU=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=ECpKQX736Synfjpj3jXP58IzIlR8F/+HeShuk6PLG9+VSQDEtYriTRcFNuuGb417l
         Cctr7JZAeJBEFMFSm5jWne0OVN0rTQppp6+Qm2En5dxD03AgQdNb2kqmp7MIolsvwn
         gtZVn51KbdwzyD/GRhxC05ZKPAfaJ8aixFSeVagk=
Date:   Thu, 15 Oct 2020 20:10:41 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, corbet@lwn.net, davem@davemloft.net,
        jarkko.sakkinen@linux.intel.com, joe@perches.com,
        keescook@chromium.org, mchehab+huawei@kernel.org,
        mm-commits@vger.kernel.org, robh@kernel.org,
        torvalds@linux-foundation.org
Subject:  [patch 102/156] MAINTAINERS:
 jarkko.sakkinen@linux.intel.com -> jarkko@kernel.org
Message-ID: <20201016031041.bGsbnnU0n%akpm@linux-foundation.org>
In-Reply-To: <20201015194043.84cda0c1d6ca2a6847f2384a@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

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
