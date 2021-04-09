Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 33871C43461
	for <mm-commits@archiver.kernel.org>; Fri,  9 Apr 2021 20:27:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 116EC61178
	for <mm-commits@archiver.kernel.org>; Fri,  9 Apr 2021 20:27:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233998AbhDIU1V (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 9 Apr 2021 16:27:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:51142 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233824AbhDIU1V (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 9 Apr 2021 16:27:21 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C197F61007;
        Fri,  9 Apr 2021 20:27:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1618000028;
        bh=wpvilqrFx+c2wNl1Ogy5A34qIHVprDIPwr4XsuCGUTE=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=B7/GUOJhDpMmvYjfEAIYyKZWbPHDbn5sPL3m0YoDznPo+Gg/m4l2gZRnN9+P1P60T
         aCCHnddyvp60Ll+xvEn3LJeWWAu0upAUpv9hwanl4pXbENAqdfqQmW+zkGfQYH/08+
         XQWyLkv9WMU4bQeqmbGuYgCbgJH0LIRvdPc5wt9o=
Date:   Fri, 09 Apr 2021 13:27:07 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, alobakin@pm.me, corbet@lwn.net,
        jordan@cosmicpenguin.net, keescook@chromium.org,
        linux-mm@kvack.org, mm-commits@vger.kernel.org, ojeda@kernel.org,
        torvalds@linux-foundation.org, tsbogend@alpha.franken.de
Subject:  [patch 03/16] mailmap: update email address for Jordan
 Crouse
Message-ID: <20210409202707.iMLYLWy0K%akpm@linux-foundation.org>
In-Reply-To: <20210409132633.6855fc8fea1b3905ea1bb4be@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Jordan Crouse <jordan@cosmicpenguin.net>
Subject: mailmap: update email address for Jordan Crouse

jcrouse at codeaurora.org has started bouncing.  Redirect to a more
permanent address.

Link: https://lkml.kernel.org/r/20210325143700.1490518-1-jordan@cosmicpenguin.net
Signed-off-by: Jordan Crouse <jordan@cosmicpenguin.net>
Cc: Alexander Lobakin <alobakin@pm.me>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Kees Cook <keescook@chromium.org>
Cc: Miguel Ojeda <ojeda@kernel.org>
Cc: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 .mailmap |    1 +
 1 file changed, 1 insertion(+)

--- a/.mailmap~mailmap-update-email-address-for-jordan-crouse
+++ a/.mailmap
@@ -168,6 +168,7 @@ Johan Hovold <johan@kernel.org> <jhovold
 Johan Hovold <johan@kernel.org> <johan@hovoldconsulting.com>
 John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>
 John Stultz <johnstul@us.ibm.com>
+Jordan Crouse <jordan@cosmicpenguin.net> <jcrouse@codeaurora.org>
 <josh@joshtriplett.org> <josh@freedesktop.org>
 <josh@joshtriplett.org> <josh@kernel.org>
 <josh@joshtriplett.org> <josht@linux.vnet.ibm.com>
_
