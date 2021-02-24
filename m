Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 33637C433E0
	for <mm-commits@archiver.kernel.org>; Wed, 24 Feb 2021 20:22:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D138064E20
	for <mm-commits@archiver.kernel.org>; Wed, 24 Feb 2021 20:22:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233440AbhBXUVw (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 24 Feb 2021 15:21:52 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:40402 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232446AbhBXUVv (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 24 Feb 2021 15:21:51 -0500
Received: from ip5f5af0a0.dynamic.kabel-deutschland.de ([95.90.240.160] helo=wittgenstein)
        by youngberry.canonical.com with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <christian.brauner@ubuntu.com>)
        id 1lF0eb-000139-I6; Wed, 24 Feb 2021 20:21:01 +0000
Date:   Wed, 24 Feb 2021 21:21:00 +0100
From:   Christian Brauner <christian.brauner@ubuntu.com>
To:     Andrew Morton <akpm@linux-foundation.org>
Cc:     adobriyan@gmail.com, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, torvalds@linux-foundation.org,
        viro@zeniv.linux.org.uk
Subject: Re: [patch 013/173] ramfs: support O_TMPFILE
Message-ID: <20210224202100.4d4edmifnjoni6mv@wittgenstein>
References: <20210224115824.1e289a6895087f10c41dd8d6@linux-foundation.org>
 <20210224200051.MRGrUqyzj%akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20210224200051.MRGrUqyzj%akpm@linux-foundation.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

On Wed, Feb 24, 2021 at 12:00:51PM -0800, Andrew Morton wrote:
> From: Alexey Dobriyan <adobriyan@gmail.com>
> Subject: ramfs: support O_TMPFILE
> 
> [akpm@linux-foundation.org: update inode_operations.tmpfile]
> Link: http://lkml.kernel.org/r/20190206073349.GA15311@avx2
> Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
> Cc: Christian Brauner <christian.brauner@ubuntu.com>
> Cc: Al Viro <viro@zeniv.linux.org.uk>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> ---

Looks good, thank you for porting this patch!
Acked-by: Christian Brauner <christian.brauner@ubuntu.com>
