Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7029EC43334
	for <mm-commits@archiver.kernel.org>; Mon,  6 Jun 2022 18:58:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231582AbiFFS6G (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 6 Jun 2022 14:58:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36770 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230448AbiFFS6F (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 6 Jun 2022 14:58:05 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F2DD72B272
        for <mm-commits@vger.kernel.org>; Mon,  6 Jun 2022 11:58:03 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id AC0E4B81B3B
        for <mm-commits@vger.kernel.org>; Mon,  6 Jun 2022 18:58:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 15797C34115;
        Mon,  6 Jun 2022 18:58:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1654541881;
        bh=aGz5iMfeaLxJb/IcK3AzDFJVKs4WB5NH+g63jW8mJWk=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=D38H2J2FbniFfytvkBv8J+rYiGaZ64cRYRgI02pRuZD7rz4A3QWATOQ6hXdXRqnsr
         tPufNDoWUQxVTLbYUuOjVUASv/7OkgMUXKj+t50paXaiVxC4heQKDTsAlPGz8iW59w
         XjNfKhoDrWXBZiOWuHKwsYWDkxxBQcDBozSFO6L4=
Date:   Mon, 6 Jun 2022 11:58:00 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     "Eric W. Biederman" <ebiederm@xmission.com>
Cc:     mm-commits@vger.kernel.org, tglx@linutronix.de,
        peterz@infradead.org, mathieu.desnoyers@polymtl.ca,
        keescook@chromium.org, elver@google.com, axboe@kernel.dk,
        pmladek@suse.com
Subject: Re: +
 kthread-make-it-clear-that-kthread_create_on_node-might-be-terminated-by-any-fatal-signal.patch
 added to -mm tree
Message-Id: <20220606115800.19eeeebe776af95d756b32f1@linux-foundation.org>
In-Reply-To: <87y1y94z15.fsf@email.froward.int.ebiederm.org>
References: <20220315235159.4ED42C340E8@smtp.kernel.org>
        <87y1y94z15.fsf@email.froward.int.ebiederm.org>
X-Mailer: Sylpheed 3.7.0 (GTK+ 2.24.33; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

On Mon, 06 Jun 2022 10:00:54 -0500 "Eric W. Biederman" <ebiederm@xmission.com> wrote:

> 
> Andrew are you still planning to push this comment fix upstream?
> 

Yup.  Late this week, I expect.

