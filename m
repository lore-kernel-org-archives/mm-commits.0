Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D233FC54EBC
	for <mm-commits@archiver.kernel.org>; Tue, 10 Jan 2023 13:46:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238146AbjAJNqy (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 10 Jan 2023 08:46:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41392 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233813AbjAJNqx (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 10 Jan 2023 08:46:53 -0500
Received: from domac.alu.hr (domac.alu.unizg.hr [161.53.235.3])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C09393D9C6
        for <mm-commits@vger.kernel.org>; Tue, 10 Jan 2023 05:46:50 -0800 (PST)
Received: from localhost (localhost [127.0.0.1])
        by domac.alu.hr (Postfix) with ESMTP id 224EF604F1;
        Tue, 10 Jan 2023 14:46:48 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=alu.unizg.hr; s=mail;
        t=1673358408; bh=zAzVn8rVuRGEF1ZGWY14heNzETMVk0YQrnKs/bsha3I=;
        h=Date:Subject:To:References:From:In-Reply-To:From;
        b=bqDW8kos9P4kfjEld81RGqbttjXMsMeke5NsPyzuUUpNtOLoudUvaiS12ZncNLQBE
         QLbZuMDWkuEdCbHVFD1aPjWrlThlX73qxcBLRC3MJDdglYe+rYmGXvxxUSquX4IJ9c
         vKGq2MFxeKs2hva8j2WjpcDrLaXlS3h95fDgD+2TnYXMt3+DMvBMNgypwxL4Xy0Ppg
         1dt+FyV6+VqIxq5KGL1s1/FVkEq1Mo1YVw2aaZh2PN1OVBehbuggfv0q8/7oaSV60N
         tOFXVRtePQgMrzTpWpRfRgeAJaFNS1toAlLCbXeirV+q0Xb0jEijn0EftGJDMNLUH7
         dTevBIYMiuVTA==
X-Virus-Scanned: Debian amavisd-new at domac.alu.hr
Received: from domac.alu.hr ([127.0.0.1])
        by localhost (domac.alu.hr [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id UWrAmat8hUnE; Tue, 10 Jan 2023 14:46:45 +0100 (CET)
Received: from [193.198.186.200] (pc-mtodorov.slava.alu.hr [193.198.186.200])
        by domac.alu.hr (Postfix) with ESMTPSA id C6BA7604F0;
        Tue, 10 Jan 2023 14:46:44 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=alu.unizg.hr; s=mail;
        t=1673358405; bh=zAzVn8rVuRGEF1ZGWY14heNzETMVk0YQrnKs/bsha3I=;
        h=Date:Subject:To:References:From:In-Reply-To:From;
        b=TJrmAQvgvGkYXQSHh9yJZCzrw9IGUek8HIxSIj+HykvqjNq2C6UqH4JKY5Yb8ANM0
         hS0nJxcvJ5nmw/oCc3JEEafZf72ugNVNITZNNoLPZqohDpPQuVydVp0JnQq3hIx8By
         1Bl3bsiZvqAGTbQuKj51rpn7rvd5U1/JPJ+sQTeXjV9FZO+nNNfmuI3XZW/eAjNpKM
         K/XC66zHOivJ83RKGr3S6Ajj1OV4jGN2UaPdfvZguD6N4s289OozxQlCxgcjtkXkYq
         Y5Y5pMcJMygwWoYR5iGU/svIqHlwO1K24NRKH+CqB8mAmtE1qtzv/q63cq3uZqfZ/K
         vlZrrsWZu2BLg==
Message-ID: <ac38396d-51df-fff0-5b4c-3defea67dbe3@alu.unizg.hr>
Date:   Tue, 10 Jan 2023 14:46:44 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.0
Subject: Re: +
 selftests-mm-define-madv_pageout-to-fix-compilation-issues.patch added to
 mm-unstable branch
Content-Language: en-US, hr
To:     David Hildenbrand <david@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        mm-commits@vger.kernel.org, shuah@kernel.org
References: <20230109233601.C4082C433EF@smtp.kernel.org>
 <cb32e13b-2edd-8a4d-dfc1-779d03a1ff67@alu.unizg.hr>
 <5c273641-1a06-f595-59d7-b338f2183953@redhat.com>
 <edb402df-c0df-00d7-3bf4-884c5ba47ca9@alu.unizg.hr>
 <738e358a-5ef0-0981-ba02-8a25367b9bc9@redhat.com>
From:   Mirsad Todorovac <mirsad.todorovac@alu.unizg.hr>
In-Reply-To: <738e358a-5ef0-0981-ba02-8a25367b9bc9@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

On 1/10/23 12:56, David Hildenbrand wrote:
> On 10.01.23 12:52, Mirsad Todorovac wrote:
>>
>>
>> On 1/10/23 12:18, David Hildenbrand wrote:
>>> On 10.01.23 12:00, Mirsad Todorovac wrote:
>>>> Hi,
>>>>
>>>> On 1/10/23 00:36, Andrew Morton wrote:
>>>>> The patch titled
>>>>>         Subject: selftests/mm: define MADV_PAGEOUT to fix compilation
>>>>> issues
>>>>> has been added to the -mm mm-unstable branch.  Its filename is
>>>>>         selftests-mm-define-madv_pageout-to-fix-compilation-issues.patch
>>>>>
>>>>> This patch will shortly appear at
>>>>> https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-mm-define-madv_pageout-to-fix-compilation-issues.patch
>>>>>
>>>>> This patch will later appear in the mm-unstable branch at
>>>>>        git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
>>>>>
>>>>> Before you just go and hit "reply", please:
>>>>>       a) Consider who else should be cc'ed
>>>>>       b) Prefer to cc a suitable mailing list as well
>>>>>       c) Ideally: find the original patch on the mailing list and do a
>>>>>          reply-to-all to that, adding suitable additional cc's
>>>>>
>>>>> *** Remember to use Documentation/process/submit-checklist.rst when
>>>>> testing your code ***
>>>>>
>>>>> The -mm tree is included into linux-next via the mm-everything
>>>>> branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
>>>>> and is updated there every 2-3 working days
>>>>>
>>>>> ------------------------------------------------------
>>>>> From: David Hildenbrand <david@redhat.com>
>>>>> Subject: selftests/mm: define MADV_PAGEOUT to fix compilation issues
>>>>> Date: Mon, 9 Jan 2023 18:12:55 +0100
>>>>>
>>>>> If MADV_PAGEOUT is not defined (e.g., on AlmaLinux 8), compilation will
>>>>> fail.  Let's fix that like khugepaged.c does by conditionally defining
>>>>> MADV_PAGEOUT.
>>>>>
>>>>> Link: https://lkml.kernel.org/r/20230109171255.488749-1-david@redhat.com
>>>>> Fixes: 69c66add5663 ("selftests/vm: anon_cow: test COW handling of
>>>>> anonymous memory")
>>>>> Signed-off-by: David Hildenbrand <david@redhat.com>
>>>>> Reported-by: Mirsad Goran Todorovac <mirsad.todorovac@alu.unizg.hr>
>>>>> Cc: Shuah Khan <shuah@kernel.org>
>>>>> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
>>>>> ---
>>>>>
>>>>>     tools/testing/selftests/mm/cow.c |    3 +++
>>>>>     1 file changed, 3 insertions(+)
>>>>>
>>>>> ---
>>>>> a/tools/testing/selftests/mm/cow.c~selftests-mm-define-madv_pageout-to-fix-compilation-issues
>>>>> +++ a/tools/testing/selftests/mm/cow.c
>>>>> @@ -30,6 +30,9 @@
>>>>>     #include "../kselftest.h"
>>>>>     #include "vm_util.h"
>>>>> +#ifndef MADV_PAGEOUT
>>>>> +#define MADV_PAGEOUT 21
>>>>> +#endif
>>>>>     #ifndef MADV_COLLAPSE
>>>>>     #define MADV_COLLAPSE 25
>>>>>     #endif
>>>>> _
>>>>>
>>>>> Patches currently in -mm which might be from david@redhat.com are
>>>>>
>>>>> mm-hugetlb-fix-pte-marker-handling-in-hugetlb_change_protection.patch
>>>>> mm-hugetlb-fix-uffd-wp-handling-for-migration-entries-in-hugetlb_change_protection.patch
>>>>> mm-userfaultfd-enable-writenotify-while-userfaultfd-wp-is-enabled-for-a-vma.patch
>>>>> mm-userfaultfd-rely-on-vma-vm_page_prot-in-uffd_wp_range.patch
>>>>> mm-userfaultfd-rely-on-vma-vm_page_prot-in-uffd_wp_range-fix.patch
>>>>> mm-mprotect-drop-pgprot_t-parameter-from-change_protection.patch
>>>>> mm-mprotect-drop-pgprot_t-parameter-from-change_protection-fix.patch
>>>>> selftests-vm-cow-add-cow-tests-for-collapsing-of-pte-mapped-anon-thp.patch
>>>>> mm-nommu-factor-out-check-for-nommu-shared-mappings-into-is_nommu_shared_mapping.patch
>>>>> mm-nommu-dont-use-vm_mayshare-for-map_private-mappings.patch
>>>>> drivers-misc-open-dice-dont-touch-vm_mayshare.patch
>>>>> selftests-mm-define-madv_pageout-to-fix-compilation-issues.patch
>>>> Please consider alternative patch instead. I am submitting it for a
>>>> review.
>>>>
>>>> It would give the referential integrity to the source of the selftest/vm
>>>> subtree.
>>>>
>>>> #ifdef ... #endif encapsulation around `#define __USE_GNU` eliminates a
>>>> warning.
>>>>
>>>> RATIONALE:
>>>>
>>>> Though it is ulikely that the values of MADV_PAGEOUT,
>>>> MADV_POPULATE_READ and MADV_COLLAPSE will change, the source integrity
>>>> would benefit from having it changed in only one place,
>>>> .../usr/include/asm-generic/mman-common.h, included by >
>>>> #include <linux/mman.h>
>>>
>>> Would that imply that we're taking the in-tree sources and not the
>>> installed kernel headers?
>>>
>>> Because compilation would fail if the installed kernel headers don't
>>> define these.
>>
>> It seems that userfaultfd.c already included <linux/mman.h>,
>> so nothing is lost or gained in compilation successes, except that
>> things look more uniform, coherent and consistent?
> 
> I included it in tools/testing/selftests/mm/madv_populate.c as well BUT that was
> not sufficient to make it compile in all environments.

Hi, David,

It's unobvious why, for (as you can witness from the source)

#include <linux/mman.h> includes
#include <asm/mman.h> includes
#include <asm-generic/mman.h> which in turn includes
#include <asm-generic/mman-common.h>

that defines all of the

#define MADV_PAGEOUT    21              /* reclaim these pages */
#define MADV_POPULATE_READ      22      /* populate (prefault) page tables readable */
#define MADV_POPULATE_WRITE     23      /* populate (prefault) page tables writable */

So, everything is within the in-tree includes, so I can't tell what went wrong.

I see that "#include <linux/magic.h>" is already used.

BTW, did userfaultfd.c compile on that Debian 11.5 environment?

> commit d88825f22b8f1cad8acb429b6bf0a54c85d7b93f
> Author: David Hildenbrand <david@redhat.com>
> Date:   Mon Dec 5 20:37:14 2022 +0100
> 
>      selftests/vm: madv_populate: fix missing MADV_POPULATE_(READ|WRITE) definitions
>      The tests fail to compile in some environments (e.g., Debian 11.5 on x86).

On Debian 11 on x86_64 I had no issues (just checked). (Your fix applied.)

Only MADV_PAGEOUT is defined in /usr/include:

mtodorov@magrf:~$ grep -E '(MADV_PAGEOUT|MADV_POPULATE_READ|MADV_POPULATE_WRITE)' -r /usr/include
/usr/include/x86_64-linux-gnu/bits/mman-linux.h:# define MADV_PAGEOUT     21    /* Reclaim these pages.  */
/usr/include/asm-generic/mman-common.h:#define MADV_PAGEOUT     21              /* reclaim these pages */
mtodorov@magrf:~$

However, "memfd-secret.c" and "mlock-random-test.c" fail to include <sys/capability.h>
despite being in both /usr/include/linux/capability.h and ../../../../usr/include/sys/capability.h:

mtodorov@magrf:~/linux/kernel/linux_torvalds/tools/testing/selftests/vm$ make -k
gcc -Wall -I /home/admin/mtodorov/linux/kernel/linux_torvalds/tools/testing/selftests/../../.. -I 
/home/admin/mtodorov/linux/kernel/linux_torvalds/tools/testing/selftests/../../../usr/include  -isystem 
/home/admin/mtodorov/linux/kernel/linux_torvalds/tools/testing/selftests/../../../usr/include -no-pie     memfd_secret.c -lrt 
-lpthread -lcap -o /home/admin/mtodorov/linux/kernel/linux_torvalds/tools/testing/selftests/vm/memfd_secret
memfd_secret.c:16:10: fatal error: sys/capability.h: No such file or directory
    16 | #include <sys/capability.h>
       |          ^~~~~~~~~~~~~~~~~~
compilation terminated.
make: *** [../lib.mk:145: /home/admin/mtodorov/linux/kernel/linux_torvalds/tools/testing/selftests/vm/migration] Error 1
gcc -Wall -I /home/admin/mtodorov/linux/kernel/linux_torvalds/tools/testing/selftests/../../.. -I 
/home/admin/mtodorov/linux/kernel/linux_torvalds/tools/testing/selftests/../../../usr/include  -isystem 
/home/admin/mtodorov/linux/kernel/linux_torvalds/tools/testing/selftests/../../../usr/include -no-pie     mlock-random-test.c -lrt 
-lpthread -lcap -o /home/admin/mtodorov/linux/kernel/linux_torvalds/tools/testing/selftests/vm/mlock-random-test
mlock-random-test.c:8:10: fatal error: sys/capability.h: No such file or directory
     8 | #include <sys/capability.h>
       |          ^~~~~~~~~~~~~~~~~~
compilation terminated.

usr/include/linux/capability.h is existing, but the compiler somehow fails to find it:

mtodorov@magrf:~/linux/kernel/linux_torvalds/tools/testing/selftests/vm$ grep sys/capability.h *.c
memfd_secret.c:#include <sys/capability.h>
mlock-random-test.c:#include <sys/capability.h>
mtodorov@magrf:~/linux/kernel/linux_torvalds/tools/testing/selftests/vm$ find /usr/include -name capability.h
/usr/include/linux/capability.h
mtodorov@magrf:~/linux/kernel/linux_torvalds/tools/testing/selftests/vm$

>      Let's simply conditionally define MADV_POPULATE_(READ|WRITE) if not
>      already defined, similar to how the khugepaged.c test handles it.
>      Link: https://lkml.kernel.org/r/20221205193716.276024-3-david@redhat.com
>      Fixes: 39b2e5cae43d ("selftests/vm: make MADV_POPULATE_(READ|WRITE) use in-tree headers")
>      Signed-off-by: David Hildenbrand <david@redhat.com>
>      Cc: Shuah Khan <shuah@kernel.org>
>      Cc: Yang Li <yang.lee@linux.alibaba.com>
>      Signed-off-by: Andrew Morton <akpm@linux-foundation.org>

IMHO, I don't have your experience and knowledge, but from the fresh perspective,
kernel will bring in its own selftest suite all the defines in <linux/mman.h>
that are supported in the particular version.

AFAIK, testing with different version of kernel is not recommended.

Of course, we can easily test with "gcc -E" what exactly gets included.

We don't seem to have a uniform way of handling MADV_PAGEOUT and
MADV_POPULATE(READ|WRITE) even within different C sources within
tools/testing/selftests/vm itself, so it means that we spread the spectrum
of systems and compilations that we will break. :-/

To repeat what is obvious, I am not an authority on the Linux kernel,
but as I said, I have the benefit of a fresh perspective ...

There was an open source proverb that "more eyes see more" :)

Thanks,
Mirsad

-- 
Mirsad Goran Todorovac
Sistem inženjer
Grafički fakultet | Akademija likovnih umjetnosti
Sveučilište u Zagrebu

System engineer
Faculty of Graphic Arts | Academy of Fine Arts
University of Zagreb, Republic of Croatia
