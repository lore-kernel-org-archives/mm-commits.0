From: akpm@linux-foundation.org
Subject: [patch 010/142] scripts/spelling.txt: add several more common
 spelling mistakes
Date: Wed, 22 Feb 2017 15:40:15 -0800
Message-ID: <58ae215f.kA8H8sunBqUHCFbR%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:47984 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933767AbdBVXlz (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 22 Feb 2017 18:41:55 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, colin.king@canonical.com, joe@perches.com, keescook@chromium.org

From: Colin Ian King <colin.king@canonical.com>
Subject: scripts/spelling.txt: add several more common spelling mistakes

Lately I've been cleaning up spelling mistakes in kernel error messages
and here are some of the more common spelling mistakes that I've found
which probably should be added to this list so we don't keep on seeing
them appearing again.

Link: http://lkml.kernel.org/r/20161209173326.17662-1-colin.king@canonical.com
Signed-off-by: Colin Ian King <colin.king@canonical.com>
Acked-by: Kees Cook <keescook@chromium.org>
Cc: Joe Perches <joe@perches.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/spelling.txt |   37 +++++++++++++++++++++++++++++++++++++
 1 file changed, 37 insertions(+)

diff -puN scripts/spelling.txt~scripts-spellingtxt-add-several-more-common-spelling-mistakes scripts/spelling.txt
--- a/scripts/spelling.txt~scripts-spellingtxt-add-several-more-common-spelling-mistakes
+++ a/scripts/spelling.txt
@@ -16,6 +16,7 @@ absense||absence
 absolut||absolute
 absoulte||absolute
 acccess||access
+acceess||access
 acceleratoin||acceleration
 accelleration||acceleration
 accesing||accessing
@@ -46,6 +47,7 @@ ackowledged||acknowledged
 acording||according
 activete||activate
 acumulating||accumulating
+acumulator||accumulator
 adapater||adapter
 addional||additional
 additionaly||additionally
@@ -184,6 +186,7 @@ cacluated||calculated
 caculation||calculation
 calender||calendar
 calle||called
+callibration||calibration
 calucate||calculate
 calulate||calculate
 cancelation||cancellation
@@ -244,6 +247,7 @@ compatiblity||compatibility
 competion||completion
 compilant||compliant
 compleatly||completely
+completition||completion
 completly||completely
 complient||compliant
 componnents||components
@@ -257,6 +261,7 @@ conected||connected
 configuratoin||configuration
 configuraton||configuration
 configuretion||configuration
+configutation||configuration
 conider||consider
 conjuction||conjunction
 connectinos||connections
@@ -317,6 +322,7 @@ dependant||dependent
 depreacted||deprecated
 depreacte||deprecate
 desactivate||deactivate
+desciptor||descriptor
 desciptors||descriptors
 descripton||description
 descrition||description
@@ -417,9 +423,12 @@ extention||extension
 extracter||extractor
 faild||failed
 faill||fail
+failied||failed
+faillure||failure
 failue||failure
 failuer||failure
 faireness||fairness
+falied||failed
 faliure||failure
 familar||familiar
 fatser||faster
@@ -441,6 +450,7 @@ forseeable||foreseeable
 forse||force
 fortan||fortran
 forwardig||forwarding
+framming||framing
 framwork||framework
 frequncy||frequency
 frome||from
@@ -482,6 +492,7 @@ howver||however
 hsould||should
 hypter||hyper
 identidier||identifier
+illigal||illegal
 imblance||imbalance
 immeadiately||immediately
 immedaite||immediate
@@ -520,6 +531,7 @@ informtion||information
 infromation||information
 ingore||ignore
 inital||initial
+initalized||initialized
 initalised||initialized
 initalise||initialize
 initalize||initialize
@@ -532,6 +544,7 @@ initilize||initialize
 inofficial||unofficial
 insititute||institute
 instal||install
+instanciated||instantiated
 inteface||interface
 integreated||integrated
 integrety||integrity
@@ -557,6 +570,7 @@ intialized||initialized
 intialize||initialize
 intregral||integral
 intrrupt||interrupt
+intterrupt||interrupt
 intuative||intuitive
 invaid||invalid
 invalde||invald
@@ -567,6 +581,8 @@ invokations||invocations
 irrelevent||irrelevant
 isnt||isn't
 isssue||issue
+iternations||iterations
+itertation||iteration
 itslef||itself
 jave||java
 jeffies||jiffies
@@ -621,6 +637,7 @@ messsage||message
 messsages||messages
 microprocesspr||microprocessor
 milliseonds||milliseconds
+minium||minimum
 minumum||minimum
 miscelleneous||miscellaneous
 misformed||malformed
@@ -668,6 +685,7 @@ occurances||occurrences
 occured||occurred
 occurence||occurrence
 occure||occurred
+occured||occurred
 occuring||occurring
 offet||offset
 omitt||omit
@@ -681,8 +699,10 @@ optionnal||optional
 optmizations||optimizations
 orientatied||orientated
 orientied||oriented
+orignal||original
 otherise||otherwise
 ouput||output
+oustanding||outstanding
 overaall||overall
 overhread||overhead
 overlaping||overlapping
@@ -705,6 +725,7 @@ paramter||parameter
 paramters||parameters
 particuarly||particularly
 particularily||particularly
+partiton||partition
 pased||passed
 passin||passing
 pathes||paths
@@ -724,6 +745,7 @@ pleaes||please
 ploting||plotting
 plugable||pluggable
 poinnter||pointer
+pointeur||pointer
 poiter||pointer
 posible||possible
 positon||position
@@ -752,6 +774,7 @@ procceed||proceed
 proccesors||processors
 procesed||processed
 proces||process
+procesing||processing
 processessing||processing
 processess||processes
 processpr||processor
@@ -780,6 +803,7 @@ protable||portable
 protcol||protocol
 protecion||protection
 protocoll||protocol
+promixity||proximity
 psudo||pseudo
 psuedo||pseudo
 psychadelic||psychedelic
@@ -801,6 +825,7 @@ recommanded||recommended
 recyle||recycle
 redircet||redirect
 redirectrion||redirection
+reename||rename
 refcounf||refcount
 refence||reference
 refered||referred
@@ -944,7 +969,9 @@ suble||subtle
 substract||subtract
 succesfully||successfully
 succesful||successful
+successed||succeeded
 successfull||successful
+successfuly||successfully
 sucessfully||successfully
 sucess||success
 superflous||superfluous
@@ -960,6 +987,7 @@ suppport||support
 supress||suppress
 surpresses||suppresses
 susbsystem||subsystem
+suspeneded||suspended
 suspicously||suspiciously
 swaping||swapping
 switchs||switches
@@ -967,6 +995,7 @@ symetric||symmetric
 synax||syntax
 synchonized||synchronized
 syncronize||synchronize
+syncronized||synchronized
 syncronizing||synchronizing
 syncronus||synchronous
 syste||system
@@ -1005,22 +1034,30 @@ ture||true
 tyep||type
 udpate||update
 uesd||used
+uncommited||uncommitted
 unconditionaly||unconditionally
 underun||underrun
 unecessary||unnecessary
 unexecpted||unexpected
+unexpcted||unexpected
 unexpectd||unexpected
 unexpeted||unexpected
+unexpexted||unexpected
 unfortunatelly||unfortunately
 unifiy||unify
 unintialized||uninitialized
+unkmown||unknown
 unknonw||unknown
 unknow||unknown
 unkown||unknown
 unneedingly||unnecessarily
+unnsupported||unsupported
+unmached||unmatched
 unresgister||unregister
+unrgesiter||unregister
 unsinged||unsigned
 unstabel||unstable
+unsolicitied||unsolicited
 unsuccessfull||unsuccessful
 unsuported||unsupported
 untill||until
_
