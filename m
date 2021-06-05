Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D5A57C4743D
	for <mm-commits@archiver.kernel.org>; Sat,  5 Jun 2021 03:01:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C0EBD61417
	for <mm-commits@archiver.kernel.org>; Sat,  5 Jun 2021 03:01:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231693AbhFEDDo (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 4 Jun 2021 23:03:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:53028 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231609AbhFEDDn (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 4 Jun 2021 23:03:43 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id DA6F86140F;
        Sat,  5 Jun 2021 03:01:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1622862106;
        bh=0NIETA0mga5phnizgS3GW+tlAjKWobCsgDfoSeEqPAI=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=ditZnHKafZD1mqXHoWmzP5a93LtMu1QswVxzOfoAoPltX0xnwp7WqfKcLLAubPJx+
         kuwamrHaj0wroYYkqPizK0rSsm94kJCYD4GnBsEb3dh41Hwcjn6JwCEGTVw6bhJetZ
         caCKO4r5W5m8PCRJq2mM3NjY59/RbMKZplWGAmX4=
Date:   Fri, 04 Jun 2021 20:01:45 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, corbet@lwn.net, linux-mm@kvack.org,
        michel@lespinasse.org, mm-commits@vger.kernel.org,
        torvalds@linux-foundation.org
Subject:  [patch 13/13] mailmap: use private address for Michel
 Lespinasse
Message-ID: <20210605030145.83eawhcJD%akpm@linux-foundation.org>
In-Reply-To: <20210604200040.d8d0406caf195525620c0f3d@linux-foundation.org>
User-Agent: s-nail v14.8.16
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

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
