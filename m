From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [merged] fs-befs-replace-befs_bread-by-sb_bread.patch removed
 from -mm tree
Date: Tue, 2 Aug 2016 11:11:32 -0700
Message-ID: <20160802111132.34aa66d52d4ad01be0764988@linux-foundation.org>
References: <579fe883./nkeC+o6bDOCs3BF%akpm@linux-foundation.org>
	<57A06B91.3060009@osg.samsung.com>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:55335 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932208AbcHBSLh (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 2 Aug 2016 14:11:37 -0400
In-Reply-To: <57A06B91.3060009@osg.samsung.com>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: Luis de Bethencourt <luisbg@osg.samsung.com>
Cc: salah.triki@gmail.com, mm-commits@vger.kernel.org

On Tue, 02 Aug 2016 10:44:49 +0100 Luis de Bethencourt <luisbg@osg.samsung.com> wrote:

> Looks like these patches are dropped from the -mm tree because they are already pulled
> into linux-next via my git branch [0].
> 
> Forgive my inexperience with the process of adding git trees into the Linux development
> process. When I asked Stephen to add the befs tree to linux-next I was thinking about
> testing against any conflicts, but didn't realize about the impact from merging the
> patches twice via -mm and befs tree.

That's cool - this happens all the time.

> I should've asked you the following before doing this:
> How do you want to proceed with the befs file system patch flow?
> 
> Aiming to make your life easier and taking some of the work load. I created the git tree
> to make it easy to keep track of the patches Salah and myself Ack. I know these aren't
> high priority in your list so wanted to make it easier. You can see there is a bunch of
> patches in the for-next branch [1] where I have been the only reviewer and signed off.
> 
> Then the question is about sending them to you in a tar ball/patch bundle/git pull, or
> asking Linus to pull from my git tree. The latter means less work for you, which is part
> of the goals, but needs to wait a little bit until I get my second and third signature in
> my GPG key from kernel.org trusted people. If you prefer the former, let me know which
> process you prefer, I know you aren't a fan of git pulls.

Please ask Linus to pull the patches.

> The timing isn't great, ideally we want these cleanup patches to go through in -rc1 and
> after that the rest will wait for the next development cycle. Unless there is a bug fix,
> which might happen since I am chasing some odd behaviour in befs_find_key().
> 
> Everything will go through the mailing list as usual and patches will sit on for-next at
> least a week before moving to for-linus.

That's OK.  You might miss 4.8 but I don't think there's any rush on this
material?

