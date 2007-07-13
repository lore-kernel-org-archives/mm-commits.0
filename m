From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: - print-utsname-on-oops-on-all-architectures.patch removed from
 -mm tree
Date: Fri, 13 Jul 2007 01:25:41 -0700
Message-ID: <20070713012541.46fc04b8.akpm@linux-foundation.org>
References: <200707062207.l66M7hQA023027@imap1.linux-foundation.org>
	<Pine.LNX.4.64.0707091121570.617@internets.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:35928 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760895AbXGMI0N (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 13 Jul 2007 04:26:13 -0400
In-Reply-To: <Pine.LNX.4.64.0707091121570.617@internets.corp.google.com>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: Joshua Wise <jwise@google.com>
Cc: ak@suse.de, benh@kernel.crashing.org, ink@jurassic.park.msu.ru, linux-arch@vger.kernel.org, paulus@samba.org, rmk@arm.linux.org.uk, rth@twiddle.net, mm-commits@vger.kernel.org

On Mon, 9 Jul 2007 11:22:45 -0700 (PDT) Joshua Wise <jwise@google.com> wrote:

> OK, how's this:

I turned this into an incremental patch so we could see what changed.

Please prefer to copy a mailing list on all patches.  OK, linux-arch
was copied this time, but only by luck (I suspect)

Please avoid sending two copies of the patch in one email (one inlined
and the other attached).  Because the resulting patch will apply happily
with `patch --dry-run' and will then cause havoc when one tries to apply
it for real.

Thanks.
