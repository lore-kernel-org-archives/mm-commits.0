Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A720EC4167B
	for <mm-commits@archiver.kernel.org>; Wed,  6 Dec 2023 20:53:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1379596AbjLFUxt (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 6 Dec 2023 15:53:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39022 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1379478AbjLFUxt (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 6 Dec 2023 15:53:49 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A1BC7A3
        for <mm-commits@vger.kernel.org>; Wed,  6 Dec 2023 12:53:55 -0800 (PST)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 11E0CC433C7;
        Wed,  6 Dec 2023 20:53:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1701896035;
        bh=I1pryRj6XWiQnKv5afF2S1RhL+ww/33lMwZAbSGCik4=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=maeElBN7G6gn3pgDz8FCPcfbpQ0hdvQ4yWvHMcJtVflu1X5QvMAJ1bi4zWUS0cNKn
         MHxDJtbTvirrzG6yaJkEK1OZ1AvfXjHwRXvQRf2Wu2YSfu4Yy0Vq/lbsCvX3WQQXsc
         acM1XXLdRMQ2Qf+wsgvOi9jIsLZ1rkg/JIkrmUvk=
Date:   Wed, 6 Dec 2023 12:53:54 -0800
From:   Andrew Morton <akpm@linux-foundation.org>
To:     Kees Cook <keescook@chromium.org>
Cc:     mm-commits@vger.kernel.org, ebiederm@xmission.com,
        adobriyan@gmail.com
Subject: Re: + elf-maintainers-specifically-mention-elf.patch added to
 mm-hotfixes-unstable branch
Message-Id: <20231206125354.a056c488bf529e0ba3cc047d@linux-foundation.org>
In-Reply-To: <202312061250.525031ED@keescook>
References: <20231206175845.EF303C433C7@smtp.kernel.org>
        <202312061250.525031ED@keescook>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

On Wed, 6 Dec 2023 12:50:56 -0800 Kees Cook <keescook@chromium.org> wrote:

> On Wed, Dec 06, 2023 at 09:58:45AM -0800, Andrew Morton wrote:
> > 
> > The patch titled
> >      Subject: ELF, MAINTAINERS: specifically mention ELF
> > has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
> >      elf-maintainers-specifically-mention-elf.patch
> 
> FWIW, I've snagged this via the execve tree.

Yep, I'll drop the mm.git copy.  I normally drop when Stephen sees the
duplicate, but why hassle him.
