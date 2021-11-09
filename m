Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A4F4DC433EF
	for <mm-commits@archiver.kernel.org>; Tue,  9 Nov 2021 02:32:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 85BAB6120A
	for <mm-commits@archiver.kernel.org>; Tue,  9 Nov 2021 02:32:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235649AbhKICff (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 8 Nov 2021 21:35:35 -0500
Received: from mail.kernel.org ([198.145.29.99]:50736 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229999AbhKICff (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 8 Nov 2021 21:35:35 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 294CB61242;
        Tue,  9 Nov 2021 02:32:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1636425170;
        bh=tp8QkqhbhPMOmlTTeYTPwEJEChei6sasZTIiOfSxNjM=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=zaDbgZVewNheS0z7hlwYEt4ozrOI9l6HSQyY8J0PIlR65q383Hr6eiEJ3Pf95jc3b
         QbBmI3T2vDFF33UhlcF+0KRqQ5BHIj0ortMw1Lxc+Xxx2NrxU3BliT1x1hM5KjDEcg
         QyqVLfDaSYY09FmGS6Egq/J5Eviyy0hGzJicUWAc=
Date:   Mon, 08 Nov 2021 18:32:49 -0800
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, colin.i.king@gmail.com,
        colin.i.king@googlemail.com, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, torvalds@linux-foundation.org
Subject:  [patch 27/87] mailmap: update email address for Colin
 King
Message-ID: <20211109023249.rhzqwkX3F%akpm@linux-foundation.org>
In-Reply-To: <20211108183057.809e428e841088b657a975ec@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

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
