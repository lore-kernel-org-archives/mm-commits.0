Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 86043C433FE
	for <mm-commits@archiver.kernel.org>; Mon, 18 Oct 2021 22:16:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6EC516113D
	for <mm-commits@archiver.kernel.org>; Mon, 18 Oct 2021 22:16:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233650AbhJRWSg (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 18 Oct 2021 18:18:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:37758 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233609AbhJRWSe (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 18 Oct 2021 18:18:34 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0455460F57;
        Mon, 18 Oct 2021 22:16:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1634595383;
        bh=QJv+Ytzku8kWikDRg4IcShbH4AUPAnlzYrb5ePA/5Es=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=fi9m1yjaxOlcEo74mA331m2YxcLjRGy3rm7DmJJMtn/E/6HEo+Pqh3oxeiy0lMU8c
         deLehWWv02CZtls66gvLBtLXXixkIt5lRn4NzfF5fsueNiizrfX0jwxg5E/oRdC/yP
         GISVsoCivwsF0W/blQzBrwKabQBY+Yib55Y4py54=
Date:   Mon, 18 Oct 2021 15:16:22 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, andrew.shadura@collabora.co.uk,
        linux-mm@kvack.org, mm-commits@vger.kernel.org,
        torvalds@linux-foundation.org
Subject:  [patch 19/19] mailmap: add Andrej Shadura
Message-ID: <20211018221622.Ll1lkZYju%akpm@linux-foundation.org>
In-Reply-To: <20211018151438.f2246e2656c041b6753a8bdd@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Andrej Shadura <andrew.shadura@collabora.co.uk>
Subject: mailmap: add Andrej Shadura

Add a mapping for my old work email for BelDisplayTech to the personal
email, and make sure the Collabora email has the correct spelling of the
first name.

Link: https://lkml.kernel.org/r/20210917091016.30232-1-andrew.shadura@collabora.co.uk
Signed-off-by: Andrej Shadura <andrew.shadura@collabora.co.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 .mailmap |    2 ++
 1 file changed, 2 insertions(+)

--- a/.mailmap~mailmap-add-andrej-shadura
+++ a/.mailmap
@@ -33,6 +33,8 @@ Al Viro <viro@zenIV.linux.org.uk>
 Andi Kleen <ak@linux.intel.com> <ak@suse.de>
 Andi Shyti <andi@etezian.org> <andi.shyti@samsung.com>
 Andreas Herrmann <aherrman@de.ibm.com>
+Andrej Shadura <andrew.shadura@collabora.co.uk>
+Andrej Shadura <andrew@shadura.me> <andrew@beldisplaytech.com>
 Andrew Morton <akpm@linux-foundation.org>
 Andrew Murray <amurray@thegoodpenguin.co.uk> <amurray@embedded-bits.co.uk>
 Andrew Murray <amurray@thegoodpenguin.co.uk> <andrew.murray@arm.com>
_
