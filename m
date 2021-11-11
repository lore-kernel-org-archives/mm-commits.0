Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 91F68C433EF
	for <mm-commits@archiver.kernel.org>; Thu, 11 Nov 2021 02:51:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 792B7610A2
	for <mm-commits@archiver.kernel.org>; Thu, 11 Nov 2021 02:51:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234547AbhKKCyl (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 10 Nov 2021 21:54:41 -0500
Received: from mail.kernel.org ([198.145.29.99]:58352 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232020AbhKKCyk (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 10 Nov 2021 21:54:40 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 76617610A2;
        Thu, 11 Nov 2021 02:51:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1636599112;
        bh=1VHi5naw5+h/ObWN/AA3TdEOTw5PuuIKLmjOakou1yU=;
        h=Date:From:To:Subject:From;
        b=mwPG4mhn0sIcNlO7YdvfhPE3zzGUYpfCmTSr8PhCDFq/YU7cXKBtFKBmHr1FfYN8l
         r4MFxgBt/aobvT5n7qRrDaHtVFDTTwiU8d0TonI+A8dK6tQy+GZC+WzZplZJ1t3+8q
         b6SFuo1jjEcXk/MZnDo2Du23I2OejUqnisr9BHA0=
Date:   Wed, 10 Nov 2021 18:51:52 -0800
From:   akpm@linux-foundation.org
To:     colin.i.king@gmail.com, colin.i.king@googlemail.com,
        mm-commits@vger.kernel.org
Subject:  [merged]
 mailmap-update-email-address-for-colin-king.patch removed from -mm tree
Message-ID: <20211111025152.21hq4qYdN%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mailmap: update email address for Colin King
has been removed from the -mm tree.  Its filename was
     mailmap-update-email-address-for-colin-king.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Colin Ian King <colin.i.king@googlemail.com>
Subject: mailmap: update email address for Colin King

Colin King has moved to Intel to update gmail and Canonical email
addresses.

Link: https://lkml.kernel.org/r/20211102231617.78569-1-colin.i.king@gmail.com
Signed-off-by: Colin Ian King <colin.i.king@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 .mailmap |    2 ++
 1 file changed, 2 insertions(+)

--- a/.mailmap~mailmap-update-email-address-for-colin-king
+++ a/.mailmap
@@ -73,6 +73,8 @@ Chris Chiu <chris.chiu@canonical.com> <c
 Chris Chiu <chris.chiu@canonical.com> <chiu@endlessos.org>
 Christophe Ricard <christophe.ricard@gmail.com>
 Christoph Hellwig <hch@lst.de>
+Colin Ian King <colin.king@intel.com> <colin.king@canonical.com>
+Colin Ian King <colin.king@intel.com> <colin.i.king@gmail.com>
 Corey Minyard <minyard@acm.org>
 Damian Hobson-Garcia <dhobsong@igel.co.jp>
 Daniel Borkmann <daniel@iogearbox.net> <danborkmann@googlemail.com>
_

Patches currently in -mm which might be from colin.i.king@googlemail.com are


