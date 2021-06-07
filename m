Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4FB7DC47094
	for <mm-commits@archiver.kernel.org>; Mon,  7 Jun 2021 20:41:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3D0C96120F
	for <mm-commits@archiver.kernel.org>; Mon,  7 Jun 2021 20:41:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231502AbhFGUnZ (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 7 Jun 2021 16:43:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:58598 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230389AbhFGUnX (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 7 Jun 2021 16:43:23 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7D1D561139;
        Mon,  7 Jun 2021 20:41:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1623098491;
        bh=rHpZEN5XDOY04/6KibEyNXWcBNYMv0dQ1tAa2JkKqN4=;
        h=Date:From:To:Subject:From;
        b=Z4RPCshaiu3/vQ6bSN2LP0ytA028s0UG9p+rzBa8yc228jw3Db0+vKRf8zBoO6MGp
         h6r8+5b3WqcvY/SghXVgqphViprqhq68JiIJER5YNlCrWSPEh+H+a5bYgbZD2Z4WbH
         3/zi23e/j67n1fvzAdaqJ0ywLp/4VFm7V3FQ2fV0=
Date:   Mon, 07 Jun 2021 13:41:31 -0700
From:   akpm@linux-foundation.org
To:     corbet@lwn.net, michel@lespinasse.org, mm-commits@vger.kernel.org
Subject:  [merged]
 mailmap-use-private-address-for-michel-lespinasse.patch removed from -mm
 tree
Message-ID: <20210607204131.ks1sMPAnc%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mailmap: use private address for Michel Lespinasse
has been removed from the -mm tree.  Its filename was
     mailmap-use-private-address-for-michel-lespinasse.patch

This patch was dropped because it was merged into mainline or a subsystem t=
ree

------------------------------------------------------
=46rom: Michel Lespinasse <michel@lespinasse.org>
Subject: mailmap: use private address for Michel Lespinasse

Link: https://lkml.kernel.org/r/20210602221225.49446-1-michel@lespinasse.org
Signed-off-by: Michel Lespinasse <michel@lespinasse.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 .mailmap |    3 +++
 1 file changed, 3 insertions(+)

--- a/.mailmap~mailmap-use-private-address-for-michel-lespinasse
+++ a/.mailmap
@@ -243,6 +243,9 @@ Maxime Ripard <mripard@kernel.org> <maxi
 Mayuresh Janorkar <mayur@ti.com>
 Michael Buesch <m@bues.ch>
 Michel D=C3=A4nzer <michel@tungstengraphics.com>
+Michel Lespinasse <michel@lespinasse.org>
+Michel Lespinasse <michel@lespinasse.org> <walken@google.com>
+Michel Lespinasse <michel@lespinasse.org> <walken@zoy.org>
 Miguel Ojeda <ojeda@kernel.org> <miguel.ojeda.sandonis@gmail.com>
 Mike Rapoport <rppt@kernel.org> <mike@compulab.co.il>
 Mike Rapoport <rppt@kernel.org> <mike.rapoport@gmail.com>
_

Patches currently in -mm which might be from michel@lespinasse.org are


